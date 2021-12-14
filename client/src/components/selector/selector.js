import { VIEW } from './views';
import { AnimatePresence, motion } from 'framer-motion';
import React, { useEffect, useState } from 'react';
import Axios from 'axios';

const url = 'https://api.apasih.site/';

export const ViewSelector = React.forwardRef((props, ref) => {
  const [value, setValue] = useState('apa');
  const [intCode, setIntCode] = useState(1);

  useEffect(() => {
    Axios.get(url + 'get/view/' + intCode).then((response) => {
      let text = '';
      if (intCode === '1') {
        text =
          'Potensi Mineral dengan Bijih Terbanyak di Kalimantan adalah ' +
          response.data[0].NamaKomoditi;
      } else if (intCode === '2') {
        text =
          'Perusahaan yang bukan PT yang menyumbang pendapatan terbesar di Indonesia adalah ' +
          response.data[0].Nama;
      } else if (intCode === '3') {
        text =
          'Perusahaan Swasta yang membeli hasil olahan sda kehutanan paling banyak tetapi tidak mengolah sumber daya alam di indonesia adalah ' +
          response.data[0].Nama;
      } else if (intCode === '4') {
        text =
          'Sumber Daya Alam yang memiliki kegunaan paling banyak adalah ' +
          response.data[0].NamaKomoditi;
      }
      setValue(text);
    });
  }, [intCode]);
  useEffect(() => {
    const mutableRef = ref.current;

    const handleClickOutside = (event) => {
      if (
        mutableRef.current &&
        !mutableRef.current.contains(event.target) &&
        props.open
      ) {
        props.onToggle();
        setQuery('');
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
    };
  }, [ref, props]);

  const [query, setQuery] = useState('');

  return (
    <div ref={ref}>
      <div className="mt-1 relative">
        <button
          type="button"
          className="bg-white relative w-full border border-gray-300 rounded-md  pl-3 pr-10 py-2 text-left cursor-default focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500 sm:text-sm"
          aria-haspopup="listbox"
          aria-expanded="true"
          aria-labelledby="listbox-label"
          onClick={props.onToggle}
        >
          <span className="font-Source truncate flex items-center">
            {props.selectedValue.title}
          </span>
          <span className="absolute inset-y-0 right-0 flex items-center pr-2 pointer-events-none">
            <svg
              className="h-5 w-5 text-gray-400"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 20 20"
              fill="currentColor"
              aria-hidden="true"
            >
              <path
                fillRule="evenodd"
                d="M10 3a1 1 0 01.707.293l3 3a1 1 0 01-1.414 1.414L10 5.414 7.707 7.707a1 1 0 01-1.414-1.414l3-3A1 1 0 0110 3zm-3.707 9.293a1 1 0 011.414 0L10 14.586l2.293-2.293a1 1 0 011.414 1.414l-3 3a1 1 0 01-1.414 0l-3-3a1 1 0 010-1.414z"
                clipRule="evenodd"
              />
            </svg>
          </span>
        </button>
        <AnimatePresence>
          {props.open && (
            <motion.ul
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              transition={{ duration: 0.1 }}
              className="absolute z-10 mt-1 w-full bg-white  max-h-80 rounded-md text-base ring-1 ring-black ring-opacity-5 focus:outline-none sm:text-sm"
              tabIndex={-1}
              role="listbox"
              aria-labelledby="listbox-label"
              aria-activedescendant="listbox-option-3"
            >
              <div className="sticky top-0 z-10 bg-white">
                <li className=" text-gray-900 cursor-default select-none relative h-12 py-2 px-3 ">
                  <input
                    type="search"
                    name="search"
                    autoComplete={'off'}
                    className=" font-Source focus:border-blue-500 border-1 border-solid block w-full h-8 px-2  sm:text-sm border-gray-300 rounded-md"
                    placeholder={'Cari Informasi'}
                    onChange={(e) => setQuery(e.target.value)}
                  />
                </li>
                <hr />
              </div>

              <div
                className={
                  'max-h-64 scrollbar scrollbar-track-gray-100 scrollbar-thumb-gray-300 hover:scrollbar-thumb-gray-600 scrollbar-thumb-rounded scrollbar-thin overflow-y-scroll'
                }
              >
                {VIEW.filter((country) =>
                  country.title.toLowerCase().startsWith(query.toLowerCase())
                ).length === 0 ? (
                  <li className="text-gray-900 cursor-default select-none relative py-2 pl-3 pr-9">
                    No countries found
                  </li>
                ) : (
                  VIEW.filter((country) =>
                    country.title.toLowerCase().startsWith(query.toLowerCase())
                  ).map((value, index) => {
                    return (
                      <li
                        key={`${props.id}-${index}`}
                        className="text-gray-900 font-Source cursor-default select-none relative py-2 pl-3 pr-9 flex items-center hover:bg-gray-50 transition"
                        id="listbox-option-0"
                        role="option"
                        aria-selected="true"
                        onClick={() => {
                          setIntCode(value.value);
                          props.onChange(value.value);
                          setQuery('');
                          props.onToggle();
                        }}
                      >
                        <span className="font-normal truncate">
                          {value.title}
                        </span>
                        {value.value === props.selectedValue.value ? (
                          <span className="text-blue-600 absolute inset-y-0 right-0 flex items-center pr-8">
                            <svg
                              className="h-5 w-5"
                              xmlns="http://www.w3.org/2000/svg"
                              viewBox="0 0 20 20"
                              fill="currentColor"
                              aria-hidden="true"
                            >
                              <path
                                fillRule="evenodd"
                                d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                                clipRule="evenodd"
                              />
                            </svg>
                          </span>
                        ) : null}
                      </li>
                    );
                  })
                )}
              </div>
            </motion.ul>
          )}
        </AnimatePresence>
      </div>
      <div
        id="conteent"
        className="absolute w-full m-auto font-Source text-center my-8"
      >
        {value}
      </div>
    </div>
  );
});

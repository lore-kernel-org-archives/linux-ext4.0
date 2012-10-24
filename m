From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: metadata_csum set but no space in dir leaf for checksum
Date: Tue, 23 Oct 2012 18:43:09 -0700
Message-ID: <20121024014309.GA25755@blackbox.djwong.org>
References: <20121017233209.7938.qmail@science.horizon.com>
Reply-To: "Darrick J. Wong" <darrick.wong@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, tytso@mit.edu,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:16970 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab2JXBnS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Oct 2012 21:43:18 -0400
Content-Disposition: inline
In-Reply-To: <20121017233209.7938.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 17, 2012 at 07:32:09PM -0400, George Spelvin wrote:
> > That said, using the fallback mode hints that the directory might have
> > something wrong with it.  Does e2fsck -D not fix it?
> 
> Well, I have run ewfsck -D and I keep seeing these problems in the syslog.
> Not since my last report to this list, however.
> 
> I also wonder about the fact that it's always nfsd that seems to hit it.
> Indeed, various access to the affected directories using conventional
> command-line utilities does not seem to re-trigger things.  But I probably
> need to purge the dcache first; I haven't explored that completely.
> 
> I just know that NFS does some unusual things to make its persistent
> cookies work across reboots.
> 
> > But before you do that, does the following patch help?
> 
> I'll reboot with it and see what happens.  Thank you!

Any more errors/corruption to report?

--D
> 
> 
> In the meantime, here are some more error messages and debugfs dumps:
> 
> 
> EXT4-fs error (device md5): ext4_dirent_csum_verify:262: inode #7281793: comm nfsd: metadata_csum set but no space in dir leaf for checksum.  Please run e2fsck -D.
> EXT4-fs error (device md5): ext4_find_entry:1217: inode #7281793: comm nfsd: checksumming directory block 0
> EXT4-fs error (device md5): ext4_dirent_csum_verify:262: inode #7128965: comm nfsd: metadata_csum set but no space in dir leaf for checksum.  Please run e2fsck -D.
> EXT4-fs error (device md5): ext4_find_entry:1217: inode #7128965: comm nfsd: checksumming directory block 0
> EXT4-fs error (device md5): ext4_dirent_csum_verify:262: inode #7292546: comm nfsd: metadata_csum set but no space in dir leaf for checksum.  Please run e2fsck -D.
> EXT4-fs error (device md5): ext4_find_entry:1217: inode #7292546: comm nfsd: checksumming directory block 0
> EXT4-fs error (device md5): ext4_dirent_csum_verify:262: inode #7351727: comm nfsd: metadata_csum set but no space in dir leaf for checksum.  Please run e2fsck -D.
> EXT4-fs error (device md5): ext4_find_entry:1217: inode #7351727: comm nfsd: checksumming directory block 0
> EXT4-fs (md5): error count: 8
> EXT4-fs (md5): initial error at 1350368130: ext4_dirent_csum_verify:262: inode 7281793
> EXT4-fs (md5): last error at 1350368296: ext4_find_entry:1217: inode 7351727
> EXT4-fs error (device md5): ext4_dirent_csum_verify:262: inode #7292546: comm nfsd: metadata_csum set but no space in dir leaf for checksum.  Please run e2fsck -D.
> EXT4-fs error (device md5): ext4_find_entry:1217: inode #7292546: comm nfsd: checksumming directory block 0
> 
> debugfs:  htree <7281793>
> Root node dump:
>          Reserved zero: 0
>          Hash Version: 1
>          Info length: 8
>          Indirect levels: 0
>          Flags: 0
> Number of entries (count): 3
> Number of entries (limit): 507
> Checksum: 0xbc657367
> Entry #0: Hash 0x00000000, block 1
> Entry #1: Hash 0x57654a2a, block 2
> Entry #2: Hash 0xaefdea6a, block 3
> 
> Entry #0: Hash 0x00000000, block 1
> Reading directory block 1, phys 177558117
> 7281947 0x003137ce-6c3b2ae2 (24) CGI::Cookie.3   
> 7281859 0x0051dbc8-45de1242 (28) Locale::Maketext.3   
> 7281917 0x01abd334-9da65f73 (32) DBM_Filter::compress.3   
> 7282069 0x02c86854-e07f39d5 (20) AutoLoader.3   
> 7281910 0x036664b2-097dbf06 (28) ExtUtils::MM_BeOS.3   
> 7282104 0x03c41416-22f6bed9 (24) Encode::PerlIO.3   
> 7281960 0x04d62398-d7f83196 (24) B::Assembler.3   
> 7281877 0x05a17c10-42fc52df (24) URI::Escape.3   
> 7281939 0x05e9bb92-a16f8a3e (20) B::Lint.3   
> 7282119 0x071ad216-e693a858 (28) URI::QueryParam.3   
> 7281951 0x07e574fe-be47a13d (20) B::Stash.3   
> 7281915 0x08c5cdbc-dfd68745 (24) Encode::Byte.3   
> 7282126 0x09598c68-7e21ebae (20) filetest.3   
> 7282139 0x096a9102-3c2d4399 (16) Symbol.3   
> 7282164 0x096aec46-6c08dd7c (20) overload.3   
> 7281975 0x0a1f666a-7cbe4147 (16) Thread.3   
> 7282083 0x0afdeb6e-8b09a6d8 (20) B::Xref.3   
> 7281953 0x0b2b63e0-f4655d44 (28) IO::Socket::INET.3   
> 7281844 0x0b385020-ac503f24 (20) File::Path.3   
> 7281921 0x0b453728-749d6571 (28) ExtUtils::MM_VMS.3   
> 7281832 0x0b48d114-8f4870a7 (20) GDBM_File.3   
> 7282007 0x0ba11168-f9d9ce03 (20) B::Debug.3   
> 7281870 0x0bfd3f6c-b44f5f98 (36) Locale::Maketext::TPJ13.3   
> 7281930 0x0c2b0038-0a0a510a (24) URI::WithBase.3   
> 7282095 0x0c85cea0-dd491f8a (24) Math::BigRat.3   
> 7281933 0x0ce0f1cc-44e03b49 (20) AutoSplit.3   
> 7282032 0x0d453502-64d1f688 (28) ExtUtils::Embed.3   
> 7282009 0x0e9902bc-874fa100 (20) B::Deparse.3   
> 7281916 0x0f23c8b8-25a871c4 (16) Cwd.3   
> 7282063 0x1077f454-668ef1db (20) warnings.3   
> 7282113 0x10fd7a90-ab35cebe (24) CGI::Apache.3   
> 7282029 0x11c44064-755ad312 (16) vmsish.3   
> 7281971 0x12008206-dfe59892 (24) diagnostics.3   
> 7282044 0x1208a444-68f19fb8 (16) Socket.3   
> 7281996 0x13628918-cdfadbd4 (20) DirHandle.3   
> 7282079 0x138a9870-52137dc1 (16) Fcntl.3   
> 7281973 0x13b42094-1ec9e695 (20) IO::Pipe.3   
> 7281992 0x1437e8ee-faabcba5 (20) Tie::Hash.3   
> 7281948 0x14512872-cdc65023 (20) IO::Lines.3   
> 7282062 0x14fa8e6a-f320f91d (20) CGI::Carp.3   
> 7282158 0x15f2bb22-434e8de6 (20) Net::Ping.3   
> 7281861 0x16f4822e-92690c24 (32) Pod::Perldoc::ToPod.3   
> 7281863 0x17330f5e-c490c30a (24) Digest::base.3   
> 7281842 0x175a59b2-b7758772 (24) XS::Typemap.3   
> 7282145 0x177418ea-487b401e (24) Math::BigFloat.3   
> 7282048 0x17770856-3b573ae9 (24) User::grent.3   
> 7282019 0x177c0af4-7a2ff56c (20) Term::Cap.3   
> 7281892 0x17e3fbd0-40196da7 (20) IPC::Open2.3   
> 7282059 0x189e8dfe-444f6924 (28) Parse::RecDescent.3   
> 7282111 0x19229882-65eadab1 (24) IO::InnerFile.3   
> 7282106 0x192f7c5a-d503b2c5 (28) Memoize::Expire.3   
> 7281839 0x1a806ea8-287e2743 (24) File::DosGlob.3   
> 7281989 0x1b09937e-16072f6e (28) IO::ScalarArray.3   
> 7281985 0x1bfe5da6-f7dbb1d3 (28) Time::localtime.3   
> 7281893 0x1c33b6ba-b758dba7 (24) Devel::DProf.3   
> 7282028 0x1c35df5a-653f3fdd (24) I18N::LangTags.3   
> 7282108 0x1ca873d6-3329be34 (24) Sys::Hostname.3   
> 7281881 0x1e1136f4-6a0f86af (40) Spreadsheet::WriteExcel::Big.3   
> 7282137 0x1e47d32e-a894fc9c (20) Storable.3   
> 7281808 0x1f527b04-554abd1d (28) B::Disassembler.3   
> 7281955 0x1f5308d6-9fd3c3c2 (24) Text::Soundex.3   
> 7281988 0x20a2eb94-c75d2db9 (28) Filter::Util::Call.3   
> 7281967 0x22d974c0-a52354db (20) File::Find.3   
> 7282100 0x2338d672-63b2b5ea (20) ODBM_File.3   
> 7282008 0x2443b118-7aa597e8 (24) Term::Complete.3   
> 7282067 0x24ac19b4-687bf2a5 (32) Pod::Perldoc::ToNroff.3   
> 7281902 0x24bf4a84-0cbc7e89 (20) Net::Netrc.3   
> 7282068 0x24fdba48-f3a5c842 (24) Getopt::Std.3   
> 7281994 0x259b473e-e94ce2c8 (48) Spreadsheet::WriteExcel::BIFFwriter.3   
> 7281813 0x265dde8c-295c3a77 (20) FileHandle.3   
> 7282098 0x266c6be8-9e6a3da4 (20) NDBM_File.3   
> 7281943 0x2a47e9b8-b43b5d2c (16) POSIX.3   
> 7281818 0x2a4aae6a-abd86d4f (16) Opcode.3   
> 7281896 0x2a859cda-8e428704 (32) Pod::Perldoc::ToMan.3   
> 7281833 0x2ab11966-621ca419 (28) ExtUtils::Constant.3   
> 7281891 0x2b5a77d6-ec85aeba (32) ExtUtils::MM_Cygwin.3   
> 7282042 0x2b65d804-d9c3b365 (40) ExtUtils::MakeMaker::vmsish.3   
> 7281801 0x2bdf0a30-a71e7df5 (24) Locale::Script.3   
> 7281898 0x2be532cc-307d68d7 (24) Image::Size.3   
> 7281882 0x2c5919e8-e67c29a3 (28) Memoize::Storable.3   
> 7282084 0x2e3c38f2-fc54665e (20) SelfLoader.3   
> 7281954 0x2e76193a-440c1075 (24) Pod::Checker.3   
> 7281936 0x2ed694c0-e30df5db (16) Shell.3   
> 7282184 0x2f64e23a-01342a8a (16) strict.3   
> 7282075 0x2f938e38-56e4f485 (20) CGI::Util.3   
> 7282173 0x2fa60774-ce0c1722 (16) Digest.3   
> 7281809 0x2fffc9c2-57a72ccd (24) Net::servent.3   
> 7281873 0x3032d40a-bae2b282 (32) Encode::Unicode::UTF7.3   
> 7282078 0x30acff48-c374fab1 (28) ExtUtils::Command.3   
> 7282103 0x31625318-503781c8 (16) blib.3   
> 7282010 0x32016414-b501edd6 (20) IO::Zlib.3   
> 7281983 0x3364b060-7254c47e (24) Encode::Symbol.3   
> 7282046 0x33758002-3344de86 (28) Unicode::Normalize.3   
> 7281854 0x339b2588-82613d8f (16) lib.3   
> 7281866 0x3569cf5a-6e1abb71 (24) Math::Complex.3   
> 7282003 0x35f15a92-e986d47e (24) Text::Balanced.3   
> 7282049 0x36c3669e-92606ec9 (20) Benchmark.3   
> 7281799 0x37b1dbaa-d6dd38fa (24) Net::Config.3   
> 7281991 0x3b947d46-6734fc03 (20) threads.3   
> 7281912 0x3bd3081a-296a35f7 (28) Pod::InputObjects.3   
> 7282053 0x3c5b28e4-86176ca0 (20) IPC::Msg.3   
> 7281961 0x3e0d833a-1ac648bf (20) integer.3   
> 7282076 0x3fd1a012-a852b674 (20) Net::FTP.3   
> 7281890 0x3fdcdd70-b71da10a (16) fields.3   
> 7281803 0x41b54090-149ee8f6 (20) FileCache.3   
> 7282130 0x421d97e8-77f81cba (20) IPC::Open3.3   
> 7281970 0x429e2618-c0f33f23 (20) sigtrap.3   
> 7281874 0x43089a68-6e24c70b (28) File::Spec::VMS.3   
> 7282055 0x43d2ecea-102cc330 (24) IPC::Semaphore.3   
> 7281860 0x44a4e686-82607b80 (32) I18N::LangTags::List.3   
> 7281841 0x44ef4478-fc45c4f4 (24) Tie::Memoize.3   
> 7281959 0x4563a994-c57b5137 (28) Pod::Text::Color.3   
> 7282056 0x464a3608-1d9afa90 (20) autouse.3   
> 7282073 0x472530ee-9f3e4448 (16) Test.3   
> 7282096 0x4776fffc-2e170905 (16) Fatal.3   
> 7282094 0x47782abe-e796ff27 (28) Term::ANSIColor.3   
> 7282027 0x47beb4cc-e347d6d8 (36) Test::Harness::Iterator.3   
> 7281876 0x47ee904c-510ebabe (28) ExtUtils::Liblist.3   
> 7281834 0x49aefb52-fb7684d6 (28) ExtUtils::MM_OS2.3   
> 7281887 0x49b9069c-c0ee42ea (16) bignum.3   
> 7282170 0x4a42e082-7263499b (20) Math::Trig.3   
> 7281895 0x4a8419bc-0246eede (20) Text::Wrap.3   
> 7282050 0x4a9bbe16-1759f3df (20) IO::Scalar.3   
> 7281972 0x4ae882aa-0ac94273 (24) Net::protoent.3   
> 7281976 0x4d349686-2ffc2146 (20) IO::Socket.3   
> 7282181 0x4d5cf7dc-0cbf47c4 (28) OLE::Storage_Lite.3   
> 7281878 0x50818afe-6e1b9966 (24) Encode::Alias.3   
> 7282066 0x5105f212-759cb1f3 (16) open.3   
> 7281831 0x51e5f392-4e023251 (32) Memoize::AnyDBM_File.3   
> 7281937 0x528e96d8-3fca906c (24) Net::libnetFAQ.3   
> 7281962 0x52beb69e-72e8b817 (24) CGI::Switch.3   
> 7281794 0x53d48054-e64bc92a (20) CGI::Push.3   
> 7282128 0x5425cbec-82948f07 (28) Exporter::Heavy.3   
> 7282040 0x54dcb0de-1a38934c (24) Pod::ParseLink.3   
> 7281894 0x554efab0-f472c3d9 (16) CPAN.3   
> 7282086 0x5597812e-6586e243 (16) NEXT.3   
> 7281829 0x55b65b52-c9776d9c (24) Test::Harness.3   
> 7281804 0x5601d6b2-ba3626fc (20) Hash::Util.3   
> 7282016 0x562c90ae-6a69f0fe (44) Spreadsheet::WriteExcel::Worksheet.3   
> 7282132 0x5710cd8e-88b8cfc9 (824) File::Spec::Unix.3   
> leaf block checksum: 0x44656c91  
> Entry #1: Hash 0x57654a2a, block 2
> Reading directory block 2, phys 177558118
> 7281845 0x57654a2a-f756161e (28) Encode::Encoder.3   
> 7281885 0x57cb0d90-7f41339f (16) Config.3   
> 7282143 0x58d551ee-e29a1a66 (16) Safe.3   
> 7282154 0x5902ae9c-109b8837 (32) Pod::Text::Overstrike.3   
> 7282116 0x5917f298-c079d2f8 (24) Sys::Syslog.3   
> 7281918 0x5a54b134-12be13d7 (24) XS::APItest.3   
> 7281974 0x5a860b74-81009666 (28) ExtUtils::MM_Unix.3   
> 7281938 0x5a92c68c-37bf507d (24) Test::Tutorial.3   
> 7282153 0x5affe78e-3fd2b049 (20) English.3   
> 7282072 0x5b626562-8eebebf0 (32) ExtUtils::Command::MM.3   
> 7282034 0x5c133ac8-5ba4fe4b (28) Locale::Language.3   
> 7281888 0x5c19e448-40bb875a (44) Text::Query::SolveAdvancedString.3   
> 7282144 0x5c737c8a-9e814a2e (28) Tie::SubstrHash.3   
> 7282133 0x5cdd29d6-562f39dc (20) Encode::JP.3   
> 7282031 0x5d11b9b4-5c0e2f6c (32) Test::Harness::Straps.3   
> 7282138 0x5d197c7a-a26a454f (20) IO::Select.3   
> 7281978 0x5dcd32ca-fce0d9a7 (28) Text::Query::Solve.3   
> 7281862 0x5e1d0c04-a4fef4ca (32) ExtUtils::Installed.3   
> 7282022 0x5ec250b6-f0901fec (28) Text::ParseWords.3   
> 7281871 0x5fc3014c-367abba7 (24) Net::hostent.3   
> 7281875 0x60ccb990-ec46acde (24) I18N::Langinfo.3   
> 7281952 0x60cd586a-c88a030d (28) Unicode::Collate.3   
> 7281798 0x60ff8568-beeb5555 (16) bigint.3   
> 7282105 0x628c7060-73eb3e37 (16) Env.3   
> 7281956 0x629bd030-64738298 (16) ops.3   
> 7282005 0x62e5f59c-03aa1153 (20) IO::Wrap.3   
> 7282149 0x62ed6b1e-3765fb01 (28) MIME::QuotedPrint.3   
> 7281850 0x639e6a96-8c50c26a (24) File::Compare.3   
> 7282038 0x64f2246c-35f052d8 (24) Encode::Guess.3   
> 7281998 0x65824c7a-d810d51d (20) Pod::Text.3   
> 7282160 0x6590ea3a-8c23b0bf (20) attributes.3   
> 7281852 0x65d6031c-3ba2bf3e (32) Encode::CJKConstants.3   
> 7281857 0x65e58d18-5b279a92 (24) ExtUtils::MY.3   
> 7282074 0x6700a786-58404e19 (24) Test::Builder.3   
> 7281835 0x6899134e-e1111da6 (24) Devel::Peek.3   
> 7281909 0x69adaea4-a6d4d230 (28) ExtUtils::MM_DOS.3   
> 7281838 0x6aca58a8-68260ed7 (28) File::Spec::Epoc.3   
> 7281950 0x6d06ca36-92f33506 (20) Time::tm.3   
> 7282146 0x6e07055e-7e9379d3 (20) Net::Time.3   
> 7282017 0x6e3e939a-5e8658f3 (20) URI::file.3   
> 7282180 0x6ef03c8a-3fbb4c63 (24) Devel::PPPort.3   
> 7281897 0x6f9ca568-ea0e9c5b (20) Dumpvalue.3   
> 7281879 0x70dde7fc-a23f9ec2 (20) File::stat.3   
> 7282065 0x70e3696e-4a5fda98 (20) B::Showlex.3   
> 7282168 0x70f8a43c-be5cd033 (20) Pod::Man.3   
> 7281820 0x718808c2-7ca0fab7 (24) Set::Crontab.3   
> 7282167 0x71c5549a-35371b9b (16) Encode.3   
> 7281812 0x71e2bcf8-74e4d7ed (28) threads::shared.3   
> 7281924 0x728712c0-30c354e2 (24) Scalar::Util.3   
> 7281995 0x728fd94e-a5e87e9a (28) ExtUtils::MM_UWIN.3   
> 7282124 0x72ef9944-d7c63bd8 (16) sort.3   
> 7281800 0x742802cc-2238fd3a (24) Math::BigInt.3   
> 7281886 0x7451c79e-a541ae38 (36) Pod::Perldoc::ToChecker.3   
> 7282087 0x7494a96e-145106ce (28) Locale::Constants.3   
> 7281987 0x75b0c17e-eb8087e9 (12) O.3   
> 7281855 0x7643ce94-058eebe7 (16) utf8.3   
> 7282006 0x76a81d86-5ce08c30 (20) File::Glob.3   
> 7282020 0x772df77e-fe63bf84 (44) Spreadsheet::WriteExcel::Format.3   
> 7281848 0x77ced664-4a766704 (28) Encode::JP::JIS7.3   
> 7281856 0x79ab9280-fcd2025f (16) bytes.3   
> 7282033 0x79b31d04-e4787e31 (20) URI::data.3   
> 7281830 0x79d9e216-1303cf69 (20) Tie::Array.3   
> 7281964 0x7c835cee-e68bb78a (28) File::CheckTree.3   
> 7282148 0x7cca7d26-6b6db300 (28) DBM_Filter::encode.3   
> 7282052 0x7d0c699e-af4e51c3 (24) Net::Telnet.3   
> 7282080 0x7d49e8e8-4f4e3c2e (28) Locale::Currency.3   
> 7281993 0x7d4c8586-c830cb35 (24) Tie::Scalar.3   
> 7281906 0x7e2f77e0-31017d5a (24) Time::Local.3   
> 7282036 0x7eaff588-b6e0a6c1 (28) Pod::ParseUtils.3   
> 7282021 0x8027c7a4-b8c189cf (20) ByteLoader.3   
> 7281884 0x8037afc2-0bf2030c (36) PerlIO::via::QuotedPrint.3   
> 7281914 0x8088141e-3c132ccc (20) URI::Split.3   
> 7281907 0x8241262e-1c0aeee0 (32) Pod::Perldoc::ToXml.3   
> 7281905 0x83cfd480-3ff3ef8e (48) Spreadsheet::WriteExcel::WorkbookBig.3   
> 7281901 0x8416a70e-09f5e264 (20) B::Concise.3   
> 7282045 0x846f8264-c44d3ca4 (32) Encode::MIME::Header.3   
> 7281957 0x849293ec-d43f92e0 (24) IO::Seekable.3   
> 7281929 0x84dfe5de-f475f7f7 (28) Devel::SelfStubber.3   
> 7281802 0x84f7f596-074ed7a5 (24) Encode::EBCDIC.3   
> 7281889 0x861e90f0-697dc23f (32) File::Spec::Functions.3   
> 7282118 0x87892862-5b529591 (20) Test::More.3   
> 7282123 0x87f58278-d40d5148 (24) Test::Simple.3   
> 7281919 0x883c0d00-e89d06df (28) ExtUtils::MM_Win95.3   
> 7281836 0x88d4bc52-584c7e0c (16) B::C.3   
> 7281805 0x8af5d0ac-cab98bf1 (20) IO::Poll.3   
> 7281913 0x8b78bd68-64e30858 (24) Net::Domain.3   
> 7282131 0x8c87f42e-30a93f23 (44) Text::Query::BuildAdvancedString.3   
> 7282077 0x8c88263e-fa61387d (28) Pod::Perldoc::ToTk.3   
> 7282057 0x8cbc41fc-31879cbc (20) Net::POP3.3   
> 7281837 0x8d419ee6-ce98d24f (20) Pod::Usage.3   
> 7281904 0x8dfc8f1c-77e1c2a6 (16) URI.3   
> 7282051 0x8e11b630-0df5bd23 (24) User::pwent.3   
> 7282176 0x8e7874ee-a5b60c24 (24) Filter::Simple.3   
> 7282058 0x8e7d28ce-135338b7 (32) Attribute::Handlers.3   
> 7281949 0x8e931d0c-a6e14b8d (32) I18N::LangTags::Detect.3   
> 7281826 0x8e969a44-00d96f2e (32) ExtUtils::Mksymlists.3   
> 7282114 0x8ea73c84-5ce3e24d (24) Getopt::Long.3   
> 7282129 0x8ff2825a-033a2148 (32) ExtUtils::MakeMaker.3   
> 7282182 0x90437378-3a9c0e0c (20) Encode::TW.3   
> 7281827 0x92571c50-cc768656 (36) Text::Query::ParseSimple.3   
> 7282155 0x9409f582-a97ba328 (48) Spreadsheet::ParseExcel::SaveParser.3   
> 7282172 0x948e1180-9d0b7981 (32) Test::Harness::Assert.3   
> 7281849 0x94bd716a-4ac0a0eb (20) B::Terse.3   
> 7282177 0x96b8d8da-7b6eab6a (28) Archive::Tar::File.3   
> 7281908 0x98b01d48-b100a8b5 (24) Text::Abbrev.3   
> 7282183 0x9a38afce-9f7469ed (24) B::Stackobj.3   
> 7281934 0x9a65be6e-fd294556 (20) Pod::LaTeX.3   
> 7281941 0x9abbbbc8-1bfb490f (28) Math::BigInt::Calc.3   
> 7281880 0x9b1429ec-5a23a0d7 (20) Tie::File.3   
> 7282090 0x9d1735e6-88162092 (24) B::Bytecode.3   
> 7282157 0x9d5981d2-6695b829 (20) Exporter.3   
> 7281968 0x9e1630ee-ac78e9e6 (20) encoding.3   
> 7281932 0x9e59ddf4-625a5415 (28) Text::Query::Build.3   
> 7282082 0xa0a8a7d6-ae987dd5 (20) List::Util.3   
> 7282175 0xa29f6404-cc583235 (28) ExtUtils::MM_Any.3   
> 7281810 0xa2da8a4c-e79f1886 (16) B::CC.3   
> 7282089 0xa32837ba-3727c83c (40) ExtUtils::MakeMaker::Tutorial.3   
> 7282061 0xa3c1f994-99edcaee (24) Encode::CN::HZ.3   
> 7282001 0xa3cc0cb6-d3b92446 (24) Tie::RefHash.3   
> 7282000 0xa485cfec-bedb6637 (28) Encode::Encoding.3   
> 7281966 0xa4fabfa6-fdbbee2b (24) Term::ReadLine.3   
> 7281828 0xa65e97de-5dc8fafa (24) IO::Stringy.3   
> 7282140 0xa67da01c-0cff8f5d (20) charnames.3   
> 7281927 0xa6eab474-04b4fc6f (36) Text::Query::ParseAdvanced.3   
> 7282156 0xa91a36a0-dc67c294 (24) Search::Dict.3   
> 7282120 0xa973bcb8-b82e3d50 (16) Carp.3   
> 7282185 0xa9ae3646-daf099a0 (24) I18N::Collate.3   
> 7282011 0xacb03a38-6603363d (24) HTML::Tagset.3   
> 7282127 0xad3d694c-70b4c389 (40) Spreadsheet::WriteExcel::Chart.3   
> 7281999 0xadecb680-c30c1e68 (832) XSLoader.3   leaf block checksum: 0x2788d34e  
> Entry #2: Hash 0xaefdea6a, block 3
> Reading directory block 3, phys 177558773
> 7282142 0xaefdea6a-923b2bcc (28) ExtUtils::MM_NW5.3   
> 7281920 0xaf61bbf2-ba044f09 (28) Text::Query::Parse.3   
> 7281822 0xb0fba70c-b7702d7d (24) Pod::Select.3   
> 7282035 0xb11673da-63ee7dce (36) Spreadsheet::WriteExcel.3   
> 7282099 0xb1b93dc0-18b73e48 (32) Pod::Perldoc::ToRtf.3   
> 7282122 0xb29f36b6-67222597 (20) IO::File.3   
> 7281807 0xb390b36a-f0f4fa87 (24) Carp::Heavy.3   
> 7281858 0xb4041c42-65607ab8 (24) Encode::Config.3   
> 7282026 0xb432c978-7a8e6e0a (28) Pod::Text::Termcap.3   
> 7281869 0xb46ed0de-ce04ef01 (16) base.3   
> 7282176 0x8e7874ee-a5b60c24 (24) Filter::Simple.3   
> 7282058 0x8e7d28ce-135338b7 (32) Attribute::Handlers.3   
> 7281949 0x8e931d0c-a6e14b8d (32) I18N::LangTags::Detect.3   
> 7281826 0x8e969a44-00d96f2e (32) ExtUtils::Mksymlists.3   
> 7282114 0x8ea73c84-5ce3e24d (24) Getopt::Long.3   
> 7282129 0x8ff2825a-033a2148 (32) ExtUtils::MakeMaker.3   
> 7282182 0x90437378-3a9c0e0c (20) Encode::TW.3   
> 7281827 0x92571c50-cc768656 (36) Text::Query::ParseSimple.3   
> 7282155 0x9409f582-a97ba328 (48) Spreadsheet::ParseExcel::SaveParser.3   
> 7282172 0x948e1180-9d0b7981 (32) Test::Harness::Assert.3   
> 7281849 0x94bd716a-4ac0a0eb (20) B::Terse.3   
> 7282177 0x96b8d8da-7b6eab6a (28) Archive::Tar::File.3   
> 7281908 0x98b01d48-b100a8b5 (24) Text::Abbrev.3   
> 7282183 0x9a38afce-9f7469ed (24) B::Stackobj.3   
> 7281934 0x9a65be6e-fd294556 (20) Pod::LaTeX.3   
> 7281941 0x9abbbbc8-1bfb490f (28) Math::BigInt::Calc.3   
> 7281880 0x9b1429ec-5a23a0d7 (20) Tie::File.3   
> 7282090 0x9d1735e6-88162092 (24) B::Bytecode.3   
> 7282157 0x9d5981d2-6695b829 (20) Exporter.3   
> 7281968 0x9e1630ee-ac78e9e6 (20) encoding.3   
> 7281932 0x9e59ddf4-625a5415 (28) Text::Query::Build.3   
> 7282082 0xa0a8a7d6-ae987dd5 (20) List::Util.3   
> 7282175 0xa29f6404-cc583235 (28) ExtUtils::MM_Any.3   
> 7281810 0xa2da8a4c-e79f1886 (16) B::CC.3   
> 7282089 0xa32837ba-3727c83c (40) ExtUtils::MakeMaker::Tutorial.3   
> 7282061 0xa3c1f994-99edcaee (24) Encode::CN::HZ.3   
> 7282001 0xa3cc0cb6-d3b92446 (24) Tie::RefHash.3   
> 7282000 0xa485cfec-bedb6637 (28) Encode::Encoding.3   
> 7281966 0xa4fabfa6-fdbbee2b (24) Term::ReadLine.3   
> 7281828 0xa65e97de-5dc8fafa (24) IO::Stringy.3   
> 7282140 0xa67da01c-0cff8f5d (20) charnames.3   
> 7281927 0xa6eab474-04b4fc6f (36) Text::Query::ParseAdvanced.3   
> 7282156 0xa91a36a0-dc67c294 (24) Search::Dict.3   
> 7282120 0xa973bcb8-b82e3d50 (16) Carp.3   
> 7282185 0xa9ae3646-daf099a0 (24) I18N::Collate.3   
> 7282011 0xacb03a38-6603363d (24) HTML::Tagset.3   
> 7282127 0xad3d694c-70b4c389 (40) Spreadsheet::WriteExcel::Chart.3   
> 7281999 0xadecb680-c30c1e68 (832) XSLoader.3   leaf block checksum: 0x2788d34e  
> Entry #2: Hash 0xaefdea6a, block 3
> Reading directory block 3, phys 177558773
> 7282142 0xaefdea6a-923b2bcc (28) ExtUtils::MM_NW5.3   
> 7281920 0xaf61bbf2-ba044f09 (28) Text::Query::Parse.3   
> 7281822 0xb0fba70c-b7702d7d (24) Pod::Select.3   
> 7282035 0xb11673da-63ee7dce (36) Spreadsheet::WriteExcel.3   
> 7282099 0xb1b93dc0-18b73e48 (32) Pod::Perldoc::ToRtf.3   
> 7282122 0xb29f36b6-67222597 (20) IO::File.3   
> 7281807 0xb390b36a-f0f4fa87 (24) Carp::Heavy.3   
> 7281858 0xb4041c42-65607ab8 (24) Encode::Config.3   
> 7282026 0xb432c978-7a8e6e0a (28) Pod::Text::Termcap.3   
> 7281869 0xb46ed0de-ce04ef01 (16) base.3   
> 7282002 0xb5ff2256-d5b3f872 (24) Archive::Tar.3   
> 7281847 0xb60b0ffc-c1cc2c86 (20) URI::ldap.3   
> 7282102 0xb64b7a40-5ce82dea (20) UNIVERSAL.3   
> 7282135 0xb6a66268-2753a7c6 (20) DBM_Filter.3   
> 7282025 0xb6c97ae2-ec127c7d (24) Class::Struct.3   
> 7282112 0xb75c8ae6-8a76d03c (28) ExtUtils::MM_MacOS.3   
> 7281824 0xb7d20e86-96506f03 (44) Spreadsheet::WriteExcel::OLEwriter.3   
> 7282141 0xb84b489a-335b6d88 (24) Thread::Queue.3   
> 7281843 0xb862c8f6-d3ec985d (28) Locale::Country.3   
> 7281817 0xb8a8f4ac-e2c32ed6 (24) Tie::Handle.3   
> 7282159 0xb9023e2e-7be0940c (12) B.3   
> 7282101 0xb9af1eec-66f2adcc (28) Encode::Supported.3   
> 7282161 0xba857eb2-41169e19 (20) Net::SMTP.3   
> 7281928 0xbadbe76a-07320fdb (28) File::Spec::Cygwin.3   
> 7282097 0xbbefb45a-09d14096 (44) Spreadsheet::WriteExcel::Workbook.3   
> 7281986 0xbcccd8bc-0b6954ec (20) Pod::Find.3   
> 7282047 0xbcd62352-b4e8189a (24) PerlIO::scalar.3   
> 7281823 0xbed3bfce-5dae44cc (24) MIME::Base64.3   
> 7281868 0xbfa3c39c-321070bd (32) Math::BigInt::CalcEmu.3   
> 7281814 0xbfe6b6c4-8e6e4a3b (24) Digest::MD5.3   
> 7281825 0xc007e5a8-96284502 (20) File::Spec.3   
> 7282030 0xc1a64edc-ef31da07 (36) Spreadsheet::ParseExcel.3   
> 7281958 0xc22951e0-b00fcb3b (12) DB.3   
> 7281984 0xc2305478-9c4bc8d0 (28) Thread::Semaphore.3   
> 7282081 0xc2d8eafc-479eb275 (24) Time::HiRes.3   
> 7282071 0xc2e8ccc8-028a2839 (24) Net::netent.3   
> 7282166 0xc321ab20-6eac18fd (44) Spreadsheet::ParseExcel::Utility.3   
> 7281946 0xc388ff82-0a4a1c49 (20) FindBin.3   
> 7281903 0xc3d98438-ba35401e (36) ExtUtils::MakeMaker::FAQ.3   
> 7281977 0xc42bb28e-d8afccc7 (20) Pod::Html.3   
> 7282013 0xc4be3b6e-d3307fe8 (24) SelectSaver.3   
> 7281872 0xc5738db2-7f9ab8cb (16) attrs.3   
> 7281846 0xc5d6908a-a41573b0 (20) constant.3   
> 7282043 0xc5e5436a-0a7e70c9 (20) DB_File.3   
> 7282151 0xc63aa68e-ece4be1c (24) URI::Heuristic.3   
> 7281926 0xc7eb425c-27ff6a77 (20) File::Temp.3   
> 7282018 0xc7f85b00-a89c9985 (24) AnyDBM_File.3   
> 7282015 0xc80c3fce-4f604020 (24) PerlIO::via.3   
> 7282165 0xc941a834-d57d8d58 (24) CGI::Pretty.3   
> 7281940 0xc941b71c-f3d574df (20) IO::Handle.3   
> 7281931 0xc9d803e2-c1a2597b (24) Time::gmtime.3   
> 7282174 0xca176a76-1b6d06e7 (28) ExtUtils::testlib.3   
> 7281942 0xcb2a3c5e-a5abda12 (32) Pod::Perldoc::ToText.3   
> 7282039 0xcc450408-285b02bf (20) CGI::Fast.3   
> 7281816 0xcd134d94-bf0c6c4a (20) IO::Dir.3   
> 7282169 0xcdb2c110-56efa280 (24) IO::WrapTie.3   
> 7282092 0xcdb3f522-371d058a (16) CGI.3   
> 7282070 0xcddc1ee4-6c7f5e7d (24) Unicode::UCD.3   
> 7281796 0xcef4ce62-dc33d604 (28) ExtUtils::MM_Win32.3   
> 7282110 0xcf5b5828-c73aaf07 (28) warnings::register.3   
> 7281806 0xd02a080a-ec775d7a (28) File::Spec::Win32.3   
> 7282107 0xd0908486-e0eee122 (28) IO::Socket::UNIX.3   
> 7282085 0xd1d85e5e-52b4f6cc (20) CPAN::Nox.3   
> 7281864 0xd3abb888-3077bedd (20) Encode::KR.3   
> 7281867 0xd41ca9f4-78d3fe60 (16) Errno.3   
> 7281819 0xd41e5962-c9323b0e (28) File::Spec::Mac.3   
> 7282091 0xd5b8f2d4-be301c84 (44) Spreadsheet::WriteExcel::Utility.3   
> 7282134 0xd5eff424-cc94570b (28) ExtUtils::Packlist.3   
> 7281865 0xd64f983c-29efda7b (24) File::Basename.3   
> 7282147 0xd696b0f4-2aa1a74d (40) Text::Query::SolveSimpleString.3   
> 7282150 0xd7cdd1f4-c3c06663 (16) less.3   
> 7281815 0xd7d2dc88-8959ad68 (24) Pod::Parser.3   
> 7282064 0xd871f4f0-e02fbe66 (16) bigrat.3   
> 7281840 0xd8e21ffc-28f0d660 (20) Memoize.3   
> 7282088 0xd8ed7334-8321fef2 (24) Pod::PlainText.3   
> 7281851 0xd8ee083c-cd1d5875 (28) Memoize::NDBM_File.3   
> 7282117 0xd95830da-21190434 (16) subs.3   
> 7282054 0xd96c1f12-7ba31a4f (24) Data::Dumper.3   
> 7282004 0xda66ecda-113de99d (20) URI::URL.3   
> 7281945 0xdb1e8af0-4827ba31 (20) B::Asmdata.3   
> 7282037 0xdccdaa2e-709356ae (28) PerlIO::encoding.3   
> 7281900 0xdf3c716c-2eae435f (28) DBM_Filter::null.3   
> 7281911 0xe04e3e08-c452ce64 (28) DBM_Filter::int32.3   
> 7281795 0xe0d57732-fdab82f9 (20) Text::Tabs.3   
> 7282179 0xe168b112-e7b043f2 (20) DynaLoader.3   
> 7281963 0xe41f02f4-050030ed (20) File::Copy.3   
> 7282060 0xe590e4fa-2cb55f55 (28) ExtUtils::Miniperl.3   
> 7281925 0xe5cb22e2-47763ab8 (20) B::Bblock.3   
> 7282178 0xe67f8a1c-da980fcf (16) PerlIO.3   
> 7282024 0xe83aa958-fa751a26 (20) Net::NNTP.3   
> 7281935 0xe8d268d8-82701949 (12) IO.3   
> 7281969 0xe9182aa6-c323c975 (24) Text::Query.3   
> 7282041 0xe968ab0e-e7c07e6c (28) DBM_Filter::utf8.3   
> 7281982 0xe9a543c2-8c97d5f9 (36) ExtUtils::MakeMaker::bytes.3   
> 7281797 0xeaf3101e-b0e77e3f (32) Text::Query::Optimize.3   
> 7282109 0xec1d503c-d9911387 (16) vars.3   
> 7282115 0xecf1d516-5e176a50 (40) Text::Query::BuildSimpleString.3   
> 7281981 0xed9d010e-eaed6c68 (32) ExtUtils::Mkbootstrap.3   
> 7281979 0xef1b0508-909b4786 (24) IO::AtomicFile.3   
> 7282023 0xef37662c-b28e7d64 (28) Memoize::SDBM_File.3   
> 7282136 0xf062d954-2431fc89 (24) ExtUtils::MM.3   
> 7281853 0xf136db5e-8f44ec17 (44) Spreadsheet::WriteExcel::Formula.3   
> 7282012 0xf197e6ce-124ec864 (20) Class::ISA.3   
> 7281883 0xf21a7de8-9a9408d6 (32) Memoize::ExpireFile.3   
> 7281811 0xf28b8540-0e50ed9b (28) Tie::ShadowHash.3   
> 7281997 0xf2c7a382-fffd3e61 (24) Pod::Plainer.3   
> 7282163 0xf3c8080e-a5e2d905 (16) locale.3   
> 7282014 0xf4fdca1e-9ad7c406 (28) Encode::JP::H2Z.3   
> 7282125 0xf5725fae-c1b904a5 (28) ExtUtils::Manifest.3   
> 7281965 0xf5ef0d6e-c66e08fb (12) if.3   
> 7281806 0xd02a080a-ec775d7a (28) File::Spec::Win32.3   
> 7282107 0xd0908486-e0eee122 (28) IO::Socket::UNIX.3   
> 7282085 0xd1d85e5e-52b4f6cc (20) CPAN::Nox.3   
> 7281864 0xd3abb888-3077bedd (20) Encode::KR.3   
> 7281867 0xd41ca9f4-78d3fe60 (16) Errno.3   
> 7281819 0xd41e5962-c9323b0e (28) File::Spec::Mac.3   
> 7282091 0xd5b8f2d4-be301c84 (44) Spreadsheet::WriteExcel::Utility.3   
> 7282134 0xd5eff424-cc94570b (28) ExtUtils::Packlist.3   
> 7281865 0xd64f983c-29efda7b (24) File::Basename.3   
> 7282147 0xd696b0f4-2aa1a74d (40) Text::Query::SolveSimpleString.3   
> 7282150 0xd7cdd1f4-c3c06663 (16) less.3   
> 7281815 0xd7d2dc88-8959ad68 (24) Pod::Parser.3   
> 7282064 0xd871f4f0-e02fbe66 (16) bigrat.3   
> 7281840 0xd8e21ffc-28f0d660 (20) Memoize.3   
> 7282088 0xd8ed7334-8321fef2 (24) Pod::PlainText.3   
> 7281851 0xd8ee083c-cd1d5875 (28) Memoize::NDBM_File.3   
> 7282117 0xd95830da-21190434 (16) subs.3   
> 7282054 0xd96c1f12-7ba31a4f (24) Data::Dumper.3   
> 7282004 0xda66ecda-113de99d (20) URI::URL.3   
> 7281945 0xdb1e8af0-4827ba31 (20) B::Asmdata.3   
> 7282037 0xdccdaa2e-709356ae (28) PerlIO::encoding.3   
> 7281900 0xdf3c716c-2eae435f (28) DBM_Filter::null.3   
> 7281911 0xe04e3e08-c452ce64 (28) DBM_Filter::int32.3   
> 7281795 0xe0d57732-fdab82f9 (20) Text::Tabs.3   
> 7282179 0xe168b112-e7b043f2 (20) DynaLoader.3   
> 7281963 0xe41f02f4-050030ed (20) File::Copy.3   
> 7282060 0xe590e4fa-2cb55f55 (28) ExtUtils::Miniperl.3   
> 7281925 0xe5cb22e2-47763ab8 (20) B::Bblock.3   
> 7282178 0xe67f8a1c-da980fcf (16) PerlIO.3   
> 7282024 0xe83aa958-fa751a26 (20) Net::NNTP.3   
> 7281935 0xe8d268d8-82701949 (12) IO.3   
> 7281969 0xe9182aa6-c323c975 (24) Text::Query.3   
> 7282041 0xe968ab0e-e7c07e6c (28) DBM_Filter::utf8.3   
> 7281982 0xe9a543c2-8c97d5f9 (36) ExtUtils::MakeMaker::bytes.3   
> 7281797 0xeaf3101e-b0e77e3f (32) Text::Query::Optimize.3   
> 7282109 0xec1d503c-d9911387 (16) vars.3   
> 7282115 0xecf1d516-5e176a50 (40) Text::Query::BuildSimpleString.3   
> 7281981 0xed9d010e-eaed6c68 (32) ExtUtils::Mkbootstrap.3   
> 7281979 0xef1b0508-909b4786 (24) IO::AtomicFile.3   
> 7282023 0xef37662c-b28e7d64 (28) Memoize::SDBM_File.3   
> 7282136 0xf062d954-2431fc89 (24) ExtUtils::MM.3   
> 7281853 0xf136db5e-8f44ec17 (44) Spreadsheet::WriteExcel::Formula.3   
> 7282012 0xf197e6ce-124ec864 (20) Class::ISA.3   
> 7281883 0xf21a7de8-9a9408d6 (32) Memoize::ExpireFile.3   
> 7281811 0xf28b8540-0e50ed9b (28) Tie::ShadowHash.3   
> 7281997 0xf2c7a382-fffd3e61 (24) Pod::Plainer.3   
> 7282163 0xf3c8080e-a5e2d905 (16) locale.3   
> 7282014 0xf4fdca1e-9ad7c406 (28) Encode::JP::H2Z.3   
> 7282125 0xf5725fae-c1b904a5 (28) ExtUtils::Manifest.3   
> 7281965 0xf5ef0d6e-c66e08fb (12) if.3   
> 7282152 0xf66dd9f8-ae12e9bb (20) SDBM_File.3   
> 7282093 0xf67d4ffc-4d203e18 (20) Encode::CN.3   
> 7281899 0xf833e8e2-944519ea (20) Net::Cmd.3   
> 7281990 0xfb5c3796-805da7c1 (12) re.3   
> 7281922 0xfb5eb786-b97f5592 (20) IPC::SysV.3   
> 7281923 0xfbdb9a48-ac6a0b85 (28) File::Spec::OS2.3   
> 7282171 0xfbf91212-ebf0391c (32) Encode::KR::2022_KR.3   
> 7282162 0xfcc1b5c6-5045921e (32) Memoize::ExpireTest.3   
> 7281980 0xfd66ca50-43a1164a (16) Switch.3   
> 7282121 0xfd7bb992-a910f4b7 (28) CPAN::FirstTime.3   
> 7281821 0xfe534750-3031ca46 (28) Encode::Unicode.3   
> 7281944 0xff1ca7a0-481ef467 (1092) ExtUtils::Install.3   
> leaf block checksum: 0x028ff755  
> ---------------------
> debugfs:  htree <7351727>
> Root node dump:
>          Reserved zero: 0
>          Hash Version: 1
>          Info length: 8
>          Indirect levels: 0
>          Flags: 0
> Number of entries (count): 2
> Number of entries (limit): 507
> Checksum: 0x9bbc3e3c
> Entry #0: Hash 0x00000000, block 1
> Entry #1: Hash 0x9d5e46c4, block 2
> 
> Entry #0: Hash 0x00000000, block 1
> Reading directory block 1, phys 179263081
> 7351780 0x0003fa54-ce2a8fe5 (44) glib-Date-and-Time-Functions.html   
> 7351848 0x01a29060-d0c476e2 (28) glib-changes.html   
> 7351737 0x01ec4a94-ccc0bc62 (36) glib-keyed-data-lists.html   
> 7351729 0x04504058-6424e57f (32) glib-N-ary-Trees.html   
> 7351804 0x088a1a28-278f8e2d (40) glib-Numerical-Definitions.html   
> 7352230 0x08ca57e8-72f410e0 (20) ix08.html   
> 7351752 0x08db08f6-90578e86 (36) glib-Memory-Allocators.html   
> 7352212 0x09d239f4-d944a7d7 (32) glib-Byte-Arrays.html   
> 7351760 0x0ad6d2f4-0d0db4c3 (36) glib-memory-allocators.html   
> 7352233 0x0d066ddc-2ec6b136 (20) tools.html   
> 7351830 0x0da1186e-e6180ec2 (32) glib-pointer-arrays.html   
> 7351812 0x0ed62200-7c8a18e1 (40) glib-Key-value-file-parser.html   
> 7351735 0x12ff76bc-d553dd92 (24) glib-caches.html   
> 7352224 0x151e2d8a-205f97f3 (20) glib.html   
> 7352229 0x16d98a7e-51711261 (20) ix07.html   
> 7351786 0x16e0ac22-e131fc65 (32) glib-Trash-Stacks.html   
> 7352221 0x16f25506-ff037c58 (28) glib-data-types.html   
> 7351828 0x170d2b22-abe58449 (40) glib-double-ended-queues.html   
> 7351849 0x1800ead4-213de8e3 (40) glib-doubly-linked-lists.html   
> 7352232 0x183b3cfc-4c416519 (16) left.png   
> 7351851 0x1986dd24-df703dca (20) style.css   
> 7351755 0x1cdf56c6-a38e9ee3 (44) glib-dynamic-loading-of-modules.html   
> 7352217 0x1cfc42da-c8fe377d (32) glib-Pointer-Arrays.html   
> 7351807 0x1d263b96-89b2b896 (28) glib-Threads.html   
> 7351754 0x1d43df70-ba7f576a (32) glib-String-Chunks.html   
> 7351784 0x1f966e14-2c334f12 (52) glib-Miscellaneous-Utility-Functions.html   
> 7351822 0x24f05f7a-f321516a (32) glib-Hash-Tables.html   
> 7351751 0x24fa2248-23cd02cf (32) glib-Memory-Slices.html   
> 7351741 0x268045e4-7333d78c (44) glib-Dynamic-Loading-of-Modules.html   
> 7351769 0x277033a2-f6d857fc (40) glib-asynchronous-queues.html   
> 7351831 0x28661aac-1afa315d (44) glib-Commandline-option-parser.html   
> 7351843 0x2a297320-bc0bcbe5 (56) glib-Perl-compatible-regular-expressions.html   
> 7351770 0x2a8913e6-4b12b818 (44) glib-warnings-and-assertions.html   
> 7351795 0x2a9c9272-06a18ed5 (28) glib-datasets.html   
> 7352215 0x2b2218a2-3307b35b (36) glib-Keyed-Data-Lists.html   
> 7352211 0x2b9f03a8-d7d838f1 (32) glib-Basic-Types.html   
> 7351833 0x2bce4daa-adcb58aa (32) glib-memory-chunks.html   
> 7351749 0x2e2107f4-3a2f8f68 (20) ix02.html   
> 7352225 0x320eafca-69f43656 (20) ix03.html   
> 7351839 0x32b9fff4-8265015a (40) glib-unicode-manipulation.html   
> 7351819 0x32de73fe-dab7ed32 (48) glib-glob-style-pattern-matching.html   
> 7351779 0x36730af0-e107a155 (32) glib-basic-types.html   
> 7351823 0x3b0b4830-f814556e (36) glib-message-logging.html   
> 7351811 0x3cd3ed24-52b97936 (40) glib-Unicode-Manipulation.html   
> 7351827 0x3ef1e944-b584666e (44) glib-Character-Set-Conversion.html   
> 7351836 0x4563c518-6260ee2f (32) glib-changes-2-0.html   
> 7351842 0x46dc646a-e1451ace (28) glib-threads.html   
> 7351728 0x484b58d6-7870756c (40) glib-numerical-definitions.html   
> 7351764 0x49576b76-a489260c (32) glib-hash-tables.html   
> 7351783 0x4c23ca5a-9f94c0e9 (32) glib-file-utilities.html   
> 7351798 0x4d1bd718-fc5c433f (44) glib-String-Utility-Functions.html   
> 7351743 0x4f22cd24-55b8a7fd (24) glib.devhelp2   
> 7351732 0x50e9aa7c-90d5035d (36) glib-Standard-Macros.html   
> 7351826 0x5299a9e2-2434b677 (28) glib-compiling.html   
> 7351766 0x52fac87a-d4cecd5a (32) glib-hook-functions.html   
> 7351761 0x576c661e-059105b5 (52) glib-miscellaneous-utility-functions.html   
> 7352223 0x5ce50e38-4aea32c6 (28) glib-resources.html   
> 7351841 0x5dcf5a44-9acc7942 (40) glib-miscellaneous-macros.html   
> 7351837 0x5ef27740-6495e1e0 (28) glib-utilities.html   
> 7352228 0x5f710de4-fb27a5f0 (20) ix06.html   
> 7351748 0x606b3176-da92a85b (40) glib-Type-Conversion-Macros.html   
> 7351781 0x6215b830-3a769dc3 (44) glib-Simple-XML-Subset-Parser.html   
> 7351791 0x627d1348-ad0a2f73 (36) glib-lexical-scanner.html   
> 7351785 0x62f119ac-e7fbf104 (36) glib-Atomic-Operations.html   
> 7351797 0x63e25e7c-71786fff (40) glib-singly-linked-lists.html   
> 7351840 0x65b713a0-cc6eace7 (32) glib-Memory-Chunks.html   
> 7351790 0x6665073e-adb07a82 (36) glib-error-reporting.html   
> 7352222 0x679971e8-1a66995b (32) glib-regex-syntax.html   
> 7351847 0x67b811a8-50903220 (32) glib-File-Utilities.html   
> 7352220 0x68f76f54-3cf8fbde (28) glib-building.html   
> 7351796 0x6c28bc4a-22e236a8 (24) glib-Quarks.html   
> 7351806 0x6f3dcaf6-8e473cf1 (40) glib-Miscellaneous-Macros.html   
> 7351838 0x70abb48c-4d7c730f (20) glib.devhelp   
> 7351817 0x7130f90e-362ed09b (32) glib-n-ary-trees.html   
> 7351740 0x725542a4-4ac41785 (36) glib-Lexical-Scanner.html   
> 7351846 0x731237ee-9889692f (44) glib-shell-related-utilities.html   
> 7352216 0x773eae0e-8c2182e2 (36) glib-Message-Logging.html   
> 7352210 0x782ca8c8-3ff542ed (48) glib-Automatic-String-Completion.html   
> 7351775 0x7a937be2-60c78fee (32) glib-trash-stacks.html   
> 7351777 0x7ac7042e-0eb907c2 (32) glib-thread-pools.html   
> 7352214 0x7acda226-f6487646 (32) glib-IO-Channels.html   
> 7352227 0x7c3e5818-47f42820 (20) ix05.html   
> 7351792 0x7e997f54-e1fbe299 (28) glib-strings.html   
> 7351759 0x7ee12f78-df7696a4 (20) index.sgml   
> 7351772 0x7ee33f12-8c3eac94 (40) glib-The-Main-Event-Loop.html   
> 7351739 0x802b9d46-6de21988 (20) index.html   
> 7351771 0x854cc6ee-1f59cbd4 (24) glib-quarks.html   
> 7352209 0x856937b4-1613d46c (24) glib-Arrays.html   
> 7352213 0x8590d6c0-f23ddb14 (28) glib-Datasets.html   
> 7351813 0x8d4333ae-32c7d0eb (24) glib-Timers.html   
> 7352219 0x8ff14b62-d76362e2 (44) glib-Warnings-and-Assertions.html   
> 7352231 0x974c56de-764d6616 (20) ix09.html   
> 7351789 0x98dc9700-b0d51228 (36) glib-spawning-processes.html   
> 7351816 0x9a05c16a-18b3ca14 (28) glib-gettextize.html   
> 7351750 0x9b106072-80f2d85b (40) glib-the-main-event-loop.html   
> 7352218 0x9b9c330c-a2efb37d (44) glib-Shell-related-Utilities.html   
> 7351850 0x9cd823e4-c74bb4b9 (44) glib-character-set-conversion.html   
> 7351810 0x9d49d18e-a9d87197 (848) glib-Bookmark-file-parser.html   
> leaf block checksum: 0xa34335f7  
> Entry #1: Hash 0x9d5e46c4, block 2
> Reading directory block 2, phys 179263082
> 7351731 0x9d5e46c4-d652091e (44) glib-simple-xml-subset-parser.html   
> 7351747 0xa21d6cfe-caf455f8 (28) glib-Sequences.html   
> 7351809 0xa2e0c704-29b58dd4 (32) glib-Thread-Pools.html   
> 7351782 0xa4aad838-8a79cc8d (44) glib-date-and-time-functions.html   
> 7351803 0xa59945ec-138c9f59 (24) glib-timers.html   
> 7351768 0xa866fc46-5c7d6f07 (20) ix01.html   
> 7351757 0xaaee3348-19ab6bd2 (52) glib-windows-compatability-functions.html   
> 7351794 0xada89760-72bec320 (24) glib-I18N.html   
> 7351763 0xaf2a44c8-819f497b (40) glib-Balanced-Binary-Trees.html   
> 7351744 0xaf64a042-186b64f2 (36) glib-standard-macros.html   
> 7351802 0xb305e942-5829363a (40) glib-Double-ended-Queues.html   
> 7351834 0xb340be6e-a85d5280 (20) right.png   
> 7351805 0xb627cbe4-75cb4b33 (32) glib-Hook-Functions.html   
> 7351787 0xba279536-be009174 (24) glib-arrays.html   
> 7351845 0xba792eb4-66a3c0a1 (36) glib-Error-Reporting.html   
> 7351832 0xbcb90dba-cfab3d64 (40) glib-Relations-and-Tuples.html   
> 7352226 0xbcc05cc2-16132b7c (20) ix04.html   
> 7351815 0xc3e474b4-fc1f01a2 (52) glib-Windows-Compatibility-Functions.html   
> 7351793 0xc4bc848c-5a4b8037 (32) glib-fundamentals.html   
> 7351765 0xc568079a-61771c7b (32) glib-byte-arrays.html   
> 7351774 0xc805002c-2aba99c1 (44) glib-string-utility-functions.html   
> 7351801 0xcabc30d8-c5c11dc5 (36) glib-Spawning-Processes.html   
> 7351730 0xcc60f91e-94079660 (40) glib-Singly-Linked-Lists.html   
> 7351758 0xcf242ac8-f1273724 (32) glib-string-chunks.html   
> 7351753 0xd1c18294-c61d429d (40) glib-Doubly-Linked-Lists.html   
> 7351814 0xd29979f8-f4cdfd4e (48) glib-Glob-style-pattern-matching.html   
> 7351767 0xd29d3c62-2ceb0e94 (52) glib-Windows-Compatability-Functions.html   
> 7351734 0xd33f0104-eb3bb30c (36) glib-Memory-Allocation.html   
> 7351799 0xd722d9d2-c3942d37 (32) glib-random-numbers.html   
> 7351756 0xd7f8329e-cff50514 (32) glib-Random-Numbers.html   
> 7351742 0xd92a8a20-7fe3188a (36) glib-Byte-Order-Macros.html   
> 7351736 0xd9381170-bfdf9b87 (40) glib-Asynchronous-Queues.html   
> 7351778 0xdc31b06a-f47f9778 (24) glib-core.html   
> 7352234 0xe18a2e52-c7a8a5f2 (16) up.png   
> 7351738 0xe204d804-34398a67 (40) glib-balanced-binary-trees.html   
> 7351820 0xe22c8d7c-5fa5b4cd (16) home.png   
> 7352208 0xe2991864-1aab2162 (32) file-name-encodings.png   
> 7351818 0xe2e828cc-151d40eb (32) glib-io-channels.html   
> 7351825 0xe5a7d0ac-b55fee64 (36) glib-cross-compiling.html   
> 7351835 0xe732a252-85160285 (36) glib-memory-allocation.html   
> 7351824 0xe8ce768c-f1a424ff (36) glib-byte-order-macros.html   
> 7351844 0xebc5ddf4-af8f98d6 (28) mainloop-states.gif   
> 7351733 0xed70db92-458a1eb2 (40) glib-type-conversion-macros.html   
> 7351773 0xf2f12c4c-9a7bec14 (24) glib-Caches.html   
> 7351746 0xf5dbc426-d7698733 (40) glib-Limits-of-Basic-Types.html   
> 7351745 0xf6f95a94-bc07044b (40) glib-relations-and-tuples.html   
> 7351829 0xf7ad92c6-8d87a05f (40) glib-Version-Information.html   
> 7351808 0xf916deda-945582a3 (28) glib-Strings.html   
> 7351788 0xfa2b8d2a-2d99be66 (36) glib-Base64-Encoding.html   
> 7351800 0xfb363b52-c4c5a37e (48) glib-automatic-string-completion.html   
> 7351776 0xfc2cc622-b000ba09 (40) glib-limits-of-basic-types.html   
> 7351762 0xfc9be558-a8669380 (2312) glib-running.html   
> leaf block checksum: 0xc32ec440  
> ---------------------
> 

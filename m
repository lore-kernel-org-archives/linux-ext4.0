From: Steve French <smfrench@gmail.com>
Subject: xfstests and ext4
Date: Thu, 13 Nov 2014 17:38:53 -0600
Message-ID: <CAH2r5murzVmOVnRchq=U-jx74U96g7N6Y42CW0iX4HKpWnbmxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	fstests@vger.kernel.org
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:61936 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964793AbaKMXjO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Nov 2014 18:39:14 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

To get xfstests to build on Ubuntu 14.10 and run (after adding various
packages I could get all but 11 of the tests to build and run) I had
to install the following packages:

sudo apt-get install xfslibs-dev uuid-dev libtool e2fsprogs automake
libuuid1 libuuidm-ocaml-dev attr libattr1-dev libacl1-dev libaio-dev
xfsprogs libgdbm-dev gawk fio dbench

The only xfstest I saw failing on ext4  (other than the defrag
problems mentioned earlier which are fixed in e2fsprogs but not picked
up by the most recent Ubuntu yet) on 3.18-rc3 kernel was generic/315
(Ubuntu 14.10).

generic/315  [failed, exit status 1] - output mismatch (see
/home/sfrench/xfstests/results//generic/315.out.bad)
    --- tests/generic/315.out 2014-11-13 11:20:05.405440282 -0800
    +++ /home/sfrench/xfstests/results//generic/315.out.bad 2014-11-13
13:34:57.346960909 -0800
    @@ -1,2 +1,6 @@
     QA output created by 315
     Slience is golden
    +ls: cannot access /mnt/test/testfile.315: No such file or directory
    +./tests/generic/315: line 69: [: : integer expression expected
    +File size is changed to ( Bytes)
    +(see /home/sfrench/xfstests/results//generic/315.full for details)


The other 157 worked on ext4 and only 11 were not run.

Ran: ext4/001 ext4/002 ext4/003 ext4/271 ext4/301 ext4/302 ext4/303
ext4/304 ext4/305 ext4/306 ext4/307 ext4/308 generic/001 generic/002
generic/003 generic/004 generic/005 generic/006 generic/007
generic/008 generic/009 generic/010 generic/011 generic/012
generic/013 generic/014 generic/015 generic/016 generic/017
generic/018 generic/020 generic/021 generic/022 generic/023
generic/024 generic/025 generic/027 generic/028 generic/029
generic/031 generic/032 generic/033 generic/034 generic/035
generic/036 generic/037 generic/053 generic/062 generic/068
generic/069 generic/070 generic/074 generic/075 generic/076
generic/077 generic/079 generic/083 generic/088 generic/089
generic/091 generic/100 generic/105 generic/112 generic/113
generic/117 generic/120 generic/123 generic/124 generic/125
generic/126 generic/127 generic/128 generic/129 generic/130
generic/131 generic/132 generic/133 generic/135 generic/141
generic/169 generic/184 generic/192 generic/193 generic/198
generic/204 generic/207 generic/208 generic/209 generic/210
generic/211 generic/212 generic/213 generic/214 generic/215
generic/219 generic/221 generic/223 generic/224 generic/225
generic/226 generic/228 generic/230 generic/231 generic/232
generic/233 generic/234 generic/235 generic/236 generic/237
generic/239 generic/240 generic/241 generic/245 generic/246
generic/247 generic/248 generic/249 generic/255 generic/256
generic/257 generic/258 generic/263 generic/269 generic/270
generic/273 generic/274 generic/299 generic/300 generic/275
generic/277 generic/280 generic/285 generic/286 generic/294
generic/306 generic/307 generic/308 generic/309 generic/310
generic/311 generic/312 generic/313 generic/314 generic/315
generic/316 generic/317 generic/318 generic/319 generic/320
generic/321 generic/322 generic/323 generic/324 generic/325 shared/006
shared/272 shared/289 shared/298
Not run: generic/019 generic/026 generic/030 generic/093 generic/097
generic/099 generic/251 generic/260 generic/288 shared/032 shared/051
Failures: generic/315 (and defrag tests ext4/302, ext4/303, ext4/304
and generic/018 which are presumably fixed upstream)

Of the 11 tests that don't run on ext4 on Ubuntu, best case seems to
be 4 more could be run if you had the right hardware and recompiled
the kernel:
3 (251, 260, 288) require TRIM support in hardware (which doesn't work in my VM)
019 requires a kernel config option (CONFIG_FAIL_MAKE_REQUEST)
026 requires maximum acl count to be specified
030 requires xfs_io mremap support
3 are IRIX specific (093, 097, 099)
and two are for different file system types (shared/032 and shared/051)


-- 
Thanks,

Steve

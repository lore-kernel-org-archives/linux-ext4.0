From: Cryptooctoploid <cryptooctoploid@gmail.com>
Subject: Re: data corruption with ext4 (from 2.6.27.4) exposed by rtorrent
Date: Wed, 5 Nov 2008 14:34:25 +0100
Message-ID: <319012f0811050534i27b7dce1t8120b3a343844adc@mail.gmail.com>
References: <3d3ce57e0811030442o377cf2bet212eefba79d714bb@mail.gmail.com>
	 <20081103134008.GE29102@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Roc Valles" <vallesroc@gmail.com>, linux-ext4@vger.kernel.org
To: "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:20193 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbYKENe0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Nov 2008 08:34:26 -0500
Received: by wf-out-1314.google.com with SMTP id 27so3862129wfd.4
        for <linux-ext4@vger.kernel.org>; Wed, 05 Nov 2008 05:34:25 -0800 (PST)
In-Reply-To: <20081103134008.GE29102@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 3, 2008 at 2:40 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Mon, Nov 03, 2008 at 12:42:11PM +0000, Roc Valles wrote:
>> Some person already reported this. I'm having the same problem.
>> http://marc.info/?l=linux-ext4&m=122557056518246&w=2
>>
>> rtorrent is a bittorrent client that makes heavy use of mmap instead
>> of read/write to avoid needless duplication of data. It has exposed
>> other bugs in the past (mmap bug in 2.6.19).
>> http://libtorrent.rakshasa.no
>> Downloading a big torrent (>2GB) with rtorrent triggers it more times
>> than not. The bigger the torrent, the higher the likeliness of
>> failure. When the torrent is finished, if a hash check is forced by
>> pressing control-r on the torrent, some blocks will fail.
>
> Can both of you send the output of "dumpe2fs -h /dev/<disk device>" of
> the filesystem in question?  The thing which I'm most interested in is
> whether the extents feature was enabled or not.  (i.e., was this a
> freshly made ext4 filesystem, or a ext3 filesystem mounted under ext4,
> and with which features eanbled?)
>

I tested this further and it turned out that this bug is not extents
related. I get the same hash failures on a partition formatted with:
-O "^extent".

Besides the torrent failures,  ext4 also managed to corrupt two
dspam sqlite3 databases on my system. (After the corruption I
get the following error:
*** glibc detected *** dspam: free(): invalid pointer: 0x0000000001e71c58 ***
======= Backtrace: =========
/lib/libc.so.6[0x7fcd1f941af6]
/lib/libc.so.6(cfree+0xbd)[0x7fcd1f942f3d]
/usr/lib64/dspam/libsqlite3_drv.so(_ds_setall_spamrecords+0x395)[0x7fcd1ea03075]
/usr/lib/libdspam.so.7(_ds_operate+0x400)[0x7fcd1fc3c710]
/usr/lib/libdspam.so.7(dspam_process+0x1d9)[0x7fcd1fc3cf49]
dspam(process_message+0xb49)[0x408579]
dspam(process_users+0x57d)[0x40902d]
dspam(main+0x2c2)[0x409832]
/lib/libc.so.6(__libc_start_main+0xfd)[0x7fcd1f8e848d]
dspam[0x402f79
and the only solution is to restore the database from ext3 backup)

My conclusion is that ext4 is not yet ready for prime time.
I moved all my data back to ext3.

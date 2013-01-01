From: "George Spelvin" <linux@horizon.com>
Subject: Re: debugfs: dump a sparse file as a new sparse file
Date: 1 Jan 2013 15:10:12 -0500
Message-ID: <20130101201012.3146.qmail@science.horizon.com>
References: <20130101020841.GA9641@thunk.org>
Cc: linux-ext4@vger.kernel.org, linux@horizon.com
To: gnehzuil.liu@gmail.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:33703 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752408Ab3AAUKO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jan 2013 15:10:14 -0500
In-Reply-To: <20130101020841.GA9641@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Nov 15, 2012 at 04:46:13AM -0000, Zheng Liu wrote:
>> --- a/debugfs/dump.c
>> +++ b/debugfs/dump.c
>> @@ -105,10 +105,11 @@ static void dump_file(const char *cmdname, ext2_ino_t ino, int fd,
>>  {
>>  	errcode_t retval;
>>  	struct ext2_inode	inode;
>> -	char 		buf[8192];
>> +	char 		buf[current_fs->blocksize];

> Note: this is a non-standard/non-portable GCC extension.  The best way
> to fix this is to explicitly malloc the buffer and then free it before
> dump_file exits.

Er... isn't that also in C99?  That should be portable enough.
Is there an actual compiler of interest that doesn't support it?

Here's a set of C99 conformance tests:
http://p99.gforge.inria.fr/c99-conformance/

Gcc, clang, icc, opencc and pcc all support VLAs.
Only tcc lacks support.  Is tcc support an important goal?

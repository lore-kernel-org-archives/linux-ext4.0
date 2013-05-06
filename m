From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: fsck memory usage
Date: Sun, 5 May 2013 19:27:57 -0600
Message-ID: <307CE092-F24C-4F8A-8AA9-B9E15C03BF3E@dilger.ca>
References: <CAEUQceh3Wm6LZpGQnXNjh0c9WbO8S70D5-KYjY8anup80WbLHQ@mail.gmail.com> <20130417230745.GC5401@thunk.org> <CAEUQceh8oX9TsOR-rtn44QtegGSGH_+QHm9GPcoVPqHGJMhWHw@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Subranshu Patel <spatel.ml@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:38024 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab3EFB15 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 May 2013 21:27:57 -0400
Received: by mail-pb0-f47.google.com with SMTP id uo1so1715992pbc.20
        for <linux-ext4@vger.kernel.org>; Sun, 05 May 2013 18:27:56 -0700 (PDT)
In-Reply-To: <CAEUQceh8oX9TsOR-rtn44QtegGSGH_+QHm9GPcoVPqHGJMhWHw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-04-30, at 8:42 PM, Subranshu Patel wrote:
>> What version of e2fsprogs are you using? There has been a number of
>> changes made to improve both CPU and memory utilization in more recent versions of e2fsprogs.
> 
> I am using version 1.41.12

Could you please retest with a recent release like 1.42.7?  That
would allow us to compare the memory usage of the newer bitmap
code.  To make it fair, it would probably be best to run the
1.41.12 and 1.42.7 e2fsck on the same image, so you should make
a copy of the block device after corrupting it, but before the
first e2fsck.

>>> Then I performed metadata corruption - 10% of the files, 10% of the directories and some superblock attributes using debugfs.
>>> Then I executed fsck to find a memory usage of around 8GB, a
>>> much larger value.
>> 
>> It's going to depend on what sort of metadata corruption was suffered.  If you need to do pass 1b/c/d fix ups, it will need
>> more memory.
>> 
>> That's pretty much unavoidable, but it's also not the common case.
>> In most use cases, if those cases require using swap, that's
>> generally OK if it's the rare case, and not the common case.
>> That's why it's not something I've really been worried about.
> 
> I used the sar command for tracking memory usage. The total memory
> usage reported by sar command is around 8GB, but it includes the
> buffer and cache memory.
> 
> memused = 8GB
> 
> buffer = 6.7GB
> 
> cache = negligible (some MBs)
> 
> So I think the effective memory usage will be 1.3GB (8 - 6.7). So the
> memory reported under buffer and cache is available for use (if any
> other process requires it). Please correct my understanding.

It would also be useful to compare the "sar" memory usage to the
usage reported by e2fsck itself with "-ttt" to see if they match
relatively well or not.

Cheers, Andreas






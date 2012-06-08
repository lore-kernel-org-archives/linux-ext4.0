From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [dm-devel] EXT4-fs error (device dm-42): ext4_mb_generate_buddy:741: group 1904, 32254 clusters in bitmap, 32258 in gd
Date: Thu, 7 Jun 2012 22:43:43 -0600
Message-ID: <53EAB777-5F48-4FCB-8CE2-9F49E29C0DCD@dilger.ca>
References: <471046920.20120604234941@eikelenboom.it> <20120605000356.GM29466@outflux.net> <1018371644.20120605224154@eikelenboom.it> <20120605210806.GB7182@thunk.org> <1883708187.20120606090126@eikelenboom.it> <CAGXu5jK-4dO59-x3eTU10OntcPwsVptjpUzQdbbHOvy9_VBQ2A@mail.gmail.com> <1482118647.20120606164012@eikelenboom.it> <20120607042756.GA30776@thunk.org> <20120607222729.GI6938@tux1.beaverton.ibm.com> <CAGXu5jKmBkfvuSR7q47-Ac57dVZynz_JkYXiA_-aXaGQiR_C4g@mail.gmail.com> <20120607225446.GK19839@thunk.org> <CAGXu5j+mF1jnMXDT-Vpb6T5s34XgTRTeDOdyoXYy_RwNfaUn6w@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>, "Darrick J. Wong" <djwong@us.ibm.com>,
	Sander Eikelenboom <linux@eikelenboom.it>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-04.shaw.ca ([64.59.134.12]:35243 "EHLO
	smtp-out-04.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2FHEnq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Jun 2012 00:43:46 -0400
In-Reply-To: <CAGXu5j+mF1jnMXDT-Vpb6T5s34XgTRTeDOdyoXYy_RwNfaUn6w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-06-07, at 5:38 PM, Kees Cook wrote:
> On Thu, Jun 7, 2012 at 3:54 PM, Ted Ts'o <tytso@mit.edu> wrote:
>> On Thu, Jun 07, 2012 at 03:40:40PM -0700, Kees Cook wrote:
>>> 
>>> FWIW, I was building the filesystem that triggered this as ext4:
>>> 
>>>   mkfs.ext4 -T default -m 0 -O ^huge_file,^flex_bg -E
>>> discard,lazy_itable_init /dev/mapper/...
>> 
>> Ouy of curiosity, was there a reason you chose those particular file
>> system parameters?  It's a surprising set, because if you're starting
>> with a fresh file system, enabling flex_bg produces a more optimal
>> file system layout.
> 
> The intent of this was to create a small (64M) initial filesystem as
> fast as possible that could be resized (to 3G) on the fly later. (The
> performance of the filesystem did not need to be optimized, just the
> speed of creation so that the create+mount would happen as fast as
> possible, to unblock things waiting for this filesystem to exist.)

Actually, flex_bg should improve mke2fs times, because the inode and
block bitmaps are allocated contiguously on disk.


Cheers, Andreas






From: Kai Grosshaus <kai@vbcl.de>
Subject: Re: [PATCH] resize2fs: support online-resizing for meta_bg and  64bits
 features
Date: Mon, 03 Sep 2012 23:02:17 +0200
Message-ID: <50451AD9.30006@vbcl.de>
References: <1346579549-25122-1-git-send-email-xiaoqiangnk@gmail.com> <CAGBYx2bobtLQmtexLtVCXSQBpK5-4-4q3MHS3bXcew=iKRhqig@mail.gmail.com> <20120903164525.GD5066@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.vbcl.de ([94.230.50.52]:38961 "EHLO mail.vbcl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab2ICVaV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Sep 2012 17:30:21 -0400
In-Reply-To: <20120903164525.GD5066@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am 03.09.2012 18:45, schrieb Theodore Ts'o:
> On Sun, Sep 02, 2012 at 06:31:19PM +0800, Yongqiang Yang wrote:
>> Hi Ted,
>>
>>      I noticed that you send out the patch enabling resizing on
>> filesystems with meta_bg and 64bits, so I send out the corresponding
>> patch on e2fsprogs.  Unfortunately, there is still a bug in e2fsprogs
>> as my last email says.
> The following two patches were sufficient for me to resize a test file
> system from 14 TB to 18 TB.  We still need to handle automatic
> enabling of the meta_bg flag in resize2fs, but this should be
> sufficient for more adventurous folks to test the online resize
> patches.  (Note that I also posted a v2 version of patch 5/5 which
> fixed a number of 64-bit overflow bugs that I found in my testing.)
>
>        	       	  	 	       	      - Ted

Hi Ted,

is offline resizeing possible with this patch without online resize 
kernel patches (i use 3.2.0) with this features?

Filesystem features:      has_journal ext_attr dir_index filetype 
needs_recovery meta_bg extent 64bit flex_bg sparse_super large_file 
huge_file uninit_bg dir_nlink extra_isize

I had no luck offline resizing my 24TB fs with e2fstools version 1.42 
and 1.42.5.

thx for your time.

Regards,

Kai Grosshaus

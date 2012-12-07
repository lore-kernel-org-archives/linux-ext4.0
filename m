From: Forrest Liu <forrestl@synology.com>
Subject: Re: [PATCH] ext4: fix extent tree corruption that incurred by hole punch
Date: Fri, 7 Dec 2012 20:13:59 +0800
Message-ID: <CAJSVwFNFr-1908AYmMKzHirub6x+ZcSkA5v8GfSY4T1rsbO4Ag@mail.gmail.com>
References: <1354623069-8124-1-git-send-email-forrestl@synology.com>
	<CAJSVwFMGZrOncF1s8xwZdDDVfYwtz_OBsKhHMGhMNZ98pQM06Q@mail.gmail.com>
	<CAJSVwFNbvUO_i8CY-g8xb1fWHgAmKgGHYx2hnJqW_TKVHSWtHA@mail.gmail.com>
	<CAOiN93kGE_mFGg+BLNYBLbeggnk-9nr5k0BDUTTq+81P9k3tWA@mail.gmail.com>
	<CAOiN93m+GQW3k41U6Nsnj6z7ez8nq113Wn_PFzYLzo4ahX734g@mail.gmail.com>
	<CAJSVwFNQUpVd0Kcua+VWx16RR9BsYnQyZYdVCWB6tVgcYA6LUQ@mail.gmail.com>
	<CAOiN93mbVSvANaUH3S-Y8mfa4uvYcc=iRO3vd4BUpAWgJMJdyA@mail.gmail.com>
	<CAJSVwFNPpsEPohbg_E-+brmR+ivO8Zfrd4LiNoY1nqOPkx_t+w@mail.gmail.com>
	<CAOiN93nAyBQgiOHP+YZjuoX8=61CWNoDQm9nzmgL8nabSuaxJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>
To: Ashish Sangwan <ashishsangwan2@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:54423 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933763Ab2LGMOA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Dec 2012 07:14:00 -0500
Received: by mail-ia0-f174.google.com with SMTP id y25so414992iay.19
        for <linux-ext4@vger.kernel.org>; Fri, 07 Dec 2012 04:13:59 -0800 (PST)
In-Reply-To: <CAOiN93nAyBQgiOHP+YZjuoX8=61CWNoDQm9nzmgL8nabSuaxJw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/12/7 Ashish Sangwan <ashishsangwan2@gmail.com>:
> On Thu, Dec 6, 2012 at 8:06 PM, Forrest Liu <forrestl@synology.com> wrote:
>> Hi Ashish,
>>
>>    There have a chance to do  a trivial update, and this case will be
>> covered in ext4_ext_remove_space.
>>
>> +       if (err == 0 && eh->eh_entries == 0 && path[depth].p_bh != NULL) {
>>                  err = ext4_ext_rm_idx(handle, inode, path + depth);
>> +               /* If this was the first extent index in node,
>> +                * propagates the ei_block updation info to top */
>> +               if(!err) {
>> +                       --depth;
>> +                       path = path + depth;
>> +                       while (--depth >= 0) {
>> +                               if (path->p_idx != EXT_FIRST_INDEX(path->p_hdr))
>> +                                       break;
>> +                               path--;
>> +                               err = ext4_ext_get_access(handle, inode, path);
>> +                               if (err)
>> +                                       break;
>>
>>         trivial update, when (path + 1)->p_idx->eh_entries == 0
>>
>> +                               path->p_idx->ei_block =(path +
>> 1)->p_idx->ei_block ;
>> +                               err = ext4_ext_dirty(handle, inode, path);
>> +                               if (err)
>> +                                       break;
>> +                       }
>> +               }
>> +       }
>> +
>>
>>    I will trying to reproduce the problem tomorrow.
> I think it will  work fine atleast till depth = 2.
> It would be great if you could check with depth > 2.
> If still having this problem, we can think more.

Hi Ashish,

First, create a file lager than 4GB, and then punch out every even blocks;
Use ex command in debugfs to dump extents, belowing is the result.

Level Entries           Logical              Physical Length Flags
 0/ 3   1/  1       1 - 1048575     40013             1048575
 1/ 3   1/  5       1 -  231160     40012             231160
 2/ 3   1/340       1 -     680     40011                680
 3/ 3   1/340       1 -       1   2228225 -   2228225      1
 3/ 3   2/340       3 -       3   2228227 -   2228227      1
 3/ 3   3/340       5 -       5   2228229 -   2228229      1


punch out 231159, 231157, ..., 1..


Level Entries           Logical              Physical Length Flags
 0/ 3   1/  1       1 - 1048575     40013             1048575
 1/ 3   1/  4  231161 -  462320   2457604             231160
 2/ 3   1/340  231161 -  231840   2457606                680
 3/ 3   1/340  231161 -  231161   2459385 -   2459385      1


Then, we get incorrect logical index, if only do correction in ext4_ext_rm_leaf.


Thanks,
Forrest

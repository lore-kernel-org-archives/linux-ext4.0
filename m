From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH] resize2fs: support online-resizing for meta_bg and 64bits features
Date: Tue, 4 Sep 2012 10:01:45 +0800
Message-ID: <CAGBYx2bj1BXEoV3UGzHaqg5KBw=H_Zdf2R1KAmZObez5SGZ9iw@mail.gmail.com>
References: <1346579549-25122-1-git-send-email-xiaoqiangnk@gmail.com>
 <CAGBYx2bobtLQmtexLtVCXSQBpK5-4-4q3MHS3bXcew=iKRhqig@mail.gmail.com> <20120903164525.GD5066@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:39050 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754492Ab2IDCCG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Sep 2012 22:02:06 -0400
Received: by lagy9 with SMTP id y9so3863693lag.19
        for <linux-ext4@vger.kernel.org>; Mon, 03 Sep 2012 19:02:05 -0700 (PDT)
In-Reply-To: <20120903164525.GD5066@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 4, 2012 at 12:45 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Sun, Sep 02, 2012 at 06:31:19PM +0800, Yongqiang Yang wrote:
>> Hi Ted,
>>
>>     I noticed that you send out the patch enabling resizing on
>> filesystems with meta_bg and 64bits, so I send out the corresponding
>> patch on e2fsprogs.  Unfortunately, there is still a bug in e2fsprogs
>> as my last email says.
>
> The following two patches were sufficient for me to resize a test file
> system from 14 TB to 18 TB.  We still need to handle automatic
> enabling of the meta_bg flag in resize2fs, but this should be
> sufficient for more adventurous folks to test the online resize
> patches.  (Note that I also posted a v2 version of patch 5/5 which
> fixed a number of 64-bit overflow bugs that I found in my testing.)
Great! I have emailed Kevin Liao who tested my patches before to have a try.

Thanks,
Yongqiang.
>
>                                               - Ted



-- 
Best Wishes
Yongqiang Yang

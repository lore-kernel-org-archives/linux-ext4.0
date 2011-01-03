From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: ext4: Fix 32bit overflow in ext4_ext_find_goal()
Date: Mon, 3 Jan 2011 09:02:56 +0200
Message-ID: <AANLkTinX9ZwGL7tj1VEHGgSm+3Hn8vw0tF0=oUSpXXOA@mail.gmail.com>
References: <4D05B132.3060402@sx.jp.nec.com>
	<20110102214031.GA10889@thunk.org>
	<F02D88CD-7463-4E10-A012-D2CE362D1E88@dilger.ca>
	<20110103041157.GE11955@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>,
	Kazuya Mio <k-mio@sx.jp.nec.com>,
	ext4 <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:48697 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab1ACHC4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Jan 2011 02:02:56 -0500
Received: by qyk12 with SMTP id 12so14735917qyk.19
        for <linux-ext4@vger.kernel.org>; Sun, 02 Jan 2011 23:02:56 -0800 (PST)
In-Reply-To: <20110103041157.GE11955@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 3, 2011 at 6:11 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Sun, Jan 02, 2011 at 08:35:39PM -0700, Andreas Dilger wrote:
>> It was written that way because HPC applications writing to a shared
>> file normally write to an offset of task_num * task_data_size so
>> they do not overlap, and end up with a dense file. Similarly,
>> bittorrent and parallel FTP clients will write dense files after
>> seeking randomly around the file, and database files often end up
>> dense as well.
>>
>> I'd rather fix the relatively few applications that expect
>> permanently sparse files to use fadvise() to notify the kernel of
>> this.
>
> Agreed, and I'm not sure there are enough applications that expect
> permanently sparse files that's worth adding a new fadvise(). =A0But =
if
> we do add a new fadvise(), the default should clearly be the current
> behavior.
>
> If someone knows of use cases where permanently sparse files are
> common, please let us know!
>

Well, there's e2image of course, but using the qcow2 format is a better
solution than fadvise in this case.

Also, I believe that if one chooses to use VM with raw image format,
it is mostly for the purpose or read performance, which implies that
the image was fallocate'd.

Am I wrong about this?

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

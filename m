From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: Re: Using tgid instead of pid in ext3_find_near()
Date: Tue, 29 Apr 2008 09:53:57 +0530
Message-ID: <ea11fea30804282123n65475715w1ead16f7b9cdbde8@mail.gmail.com>
References: <ea11fea30804281207u5fe9e96bod992dc2bb2d3fc79@mail.gmail.com>
	 <f284c33d0804281757x7433465h8828eb90a8d762ef@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Kernel Newbies" <kernelnewbies@nl.linux.org>,
	linux-ext4@vger.kernel.org
To: "Mulyadi Santosa" <mulyadi.santosa@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:40403 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbYD2EX7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Apr 2008 00:23:59 -0400
Received: by ug-out-1314.google.com with SMTP id z38so1021086ugc.16
        for <linux-ext4@vger.kernel.org>; Mon, 28 Apr 2008 21:23:58 -0700 (PDT)
In-Reply-To: <f284c33d0804281757x7433465h8828eb90a8d762ef@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 29, 2008 at 6:27 AM, Mulyadi Santosa
<mulyadi.santosa@gmail.com> wrote:
> Ehmmm....
>
>
>  On Tue, Apr 29, 2008 at 2:07 AM, Manish Katiyar <mkatiyar@gmail.com> wrote:
>  > Hi,
>  >
>  >  In the function ext*_find_near() we are using pid to have the locality
>  >  of the blocks for the files which have same functionality. Shouldn't
>  >  we be using "current->tgid" here instead ??
>  >
>  >  410 static ext3_fsblk_t ext3_find_near(struct inode *inode, Indirect *ind)
>  >   411 {
>  >  .........
>  >  ........
>  >  433  colour = (current->pid % 16) *
>  >   434    (EXT3_BLOCKS_PER_GROUP(inode->i_sb) / 16);
>  >  ........
>
>  Because each threads even on same thread group doesn't need to share
>  open file descriptors?

Hi Mulyadi,

It's not about the open file descriptors. The idea behind putting this
is to put all the blocks of same process (which may be functionally
related) nearby in the blockgroup for locality. So I think we should
be using tgid instead of pid.

Thanks

>
>  regards,
>
>  Mulyadi.
>



-- 
Thanks & Regards,
********************************************
Manish Katiyar ( http://mkatiyar.googlepages.com )
3rd Floor, Fair Winds Block
EGL Software Park
Off Intermediate Ring Road
Bangalore 560071, India
***********************************************

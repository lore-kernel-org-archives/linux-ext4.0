From: "Mulyadi Santosa" <mulyadi.santosa@gmail.com>
Subject: Re: Using tgid instead of pid in ext3_find_near()
Date: Tue, 29 Apr 2008 07:57:05 +0700
Message-ID: <f284c33d0804281757x7433465h8828eb90a8d762ef@mail.gmail.com>
References: <ea11fea30804281207u5fe9e96bod992dc2bb2d3fc79@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Kernel Newbies" <kernelnewbies@nl.linux.org>,
	linux-ext4@vger.kernel.org
To: "Manish Katiyar" <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:14630 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085AbYD2A5G (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Apr 2008 20:57:06 -0400
Received: by py-out-1112.google.com with SMTP id u52so8187735pyb.10
        for <linux-ext4@vger.kernel.org>; Mon, 28 Apr 2008 17:57:06 -0700 (PDT)
In-Reply-To: <ea11fea30804281207u5fe9e96bod992dc2bb2d3fc79@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ehmmm....

On Tue, Apr 29, 2008 at 2:07 AM, Manish Katiyar <mkatiyar@gmail.com> wrote:
> Hi,
>
>  In the function ext*_find_near() we are using pid to have the locality
>  of the blocks for the files which have same functionality. Shouldn't
>  we be using "current->tgid" here instead ??
>
>  410 static ext3_fsblk_t ext3_find_near(struct inode *inode, Indirect *ind)
>   411 {
>  .........
>  ........
>  433  colour = (current->pid % 16) *
>   434    (EXT3_BLOCKS_PER_GROUP(inode->i_sb) / 16);
>  ........

Because each threads even on same thread group doesn't need to share
open file descriptors?

regards,

Mulyadi.

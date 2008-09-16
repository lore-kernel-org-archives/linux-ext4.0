From: ashish mahamuni <ashitpro@yahoo.co.in>
Subject: Re: reading superblock
Date: Tue, 16 Sep 2008 09:47:27 +0530 (IST)
Message-ID: <756126.76299.qm@web94603.mail.in2.yahoo.com>
References: <2d08ef090809150941j3dbed8fah700aa5c9e886366@mail.gmail.com>
Reply-To: ashitpro@yahoo.co.in
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Kernelnewbies <kernelnewbies@nl.linux.org>,
	Rohit Sharma <imreckless@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from n5.bullet.mail.tp2.yahoo.com ([203.188.202.86]:43749 "HELO
	n5.bullet.mail.tp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750758AbYIPEXf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Sep 2008 00:23:35 -0400
In-Reply-To: <2d08ef090809150941j3dbed8fah700aa5c9e886366@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Rohit,

I hope you are doing this for getting hand on ext2/ext3 file systems.
So what I'll suggest is try to read the on disk data structures and read the Super Block. That will really help you to understand some part of file systems instead relying on some existing functions.
I've posted one article regarding reading super block you can look at that...
http://bytes.com/forum/thread771405.html

Regards,
Ashish 


--- On Mon, 15/9/08, Rohit Sharma <imreckless@gmail.com> wrote:

> From: Rohit Sharma <imreckless@gmail.com>
> Subject: reading superblock
> To: "Kernelnewbies" <kernelnewbies@nl.linux.org>
> Cc: "ext4" <linux-ext4@vger.kernel.org>
> Date: Monday, 15 September, 2008, 10:11 PM
> I want to read ext2 superblock and display the structure.
> 
> which function do i need to call for that.
> is it ext2_get_sb() or ext2_fill_super() or both ??
> 
> this is the function prototype:
> static int ext2_fill_super(struct super_block *sb, void
> *data, int silent)
> 
> what are the parameters data and silent used for.
> 
> --
> To unsubscribe from this list: send an email with
> "unsubscribe kernelnewbies" to
> ecartis@nl.linux.org
> Please read the FAQ at http://kernelnewbies.org/FAQ


      Get an email ID as yourname@ymail.com or yourname@rocketmail.com. Click here http://in.promos.yahoo.com/address


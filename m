From: Ganesh Patil <patil.ganesh170@gmail.com>
Subject: Re: kmalloc question.
Date: Wed, 4 Jan 2012 21:20:27 +0530
Message-ID: <CAN2Q5rsihkdYiZEgakCBjoCo1kP-ru8P6i8uzckFK8OiFDLY+w@mail.gmail.com>
References: <CAN2Q5ruw_sMPvK9hH_t_8aEKVD7rNh22g3bQU7T2uY_tSYQT3Q@mail.gmail.com>
	<FA050017-9C33-438A-BF4F-5914317C8849@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47490 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab2ADPu2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jan 2012 10:50:28 -0500
Received: by eaad14 with SMTP id d14so9464029eaa.19
        for <linux-ext4@vger.kernel.org>; Wed, 04 Jan 2012 07:50:27 -0800 (PST)
In-Reply-To: <FA050017-9C33-438A-BF4F-5914317C8849@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello sir,

         I am B.E(computer)student from Pune university (India) .my
final year project is "File system level snapshot in ext4 "  so have
to take snapshot of particular file system and place somewhere(on same
filesystem or on another filesystem) .in snapshot we are going to copy
only inode of file in to another inode. as inode size in particular
filesystem   is fixed so we cant get inode from filesystem(if
filesystem filled more than half) so finally we come to decision that
we will create one structure which has fields same as that of original
inode. so we will allocate memory dynamically using kmalloc
function.but we require that allocated memory cant be destroy till we
manually not destroy it.because of that I am asking from where kmalloc
allocates memory block(from current file system,or from kernel
space(root filesystem) or from RAM(heap area)).

On 1/4/12, Theodore Tso <tytso@mit.edu> wrote:
>
> On Jan 4, 2012, at 9:22 AM, Ganesh Patil wrote:
>
>> where allocate kmalloc function memory?
>
> Sorry, I can't parse your question.
>
> -- Ted
>
>


-- 
Regards,
Ganesh Patil.

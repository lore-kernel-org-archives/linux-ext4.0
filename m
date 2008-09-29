From: "Rohit Sharma" <imreckless@gmail.com>
Subject: Re: inode and blocks
Date: Mon, 29 Sep 2008 20:03:01 +0530
Message-ID: <2d08ef090809290733x2a58cfbl520be9810d772063@mail.gmail.com>
References: <2d08ef090809280319m64555696nfe1a446e010f921f@mail.gmail.com>
	 <20080928210118.GD8711@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>,
	Kernelnewbies <kernelnewbies@nl.linux.org>
To: "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:65423 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbYI2OdE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Sep 2008 10:33:04 -0400
Received: by gxk9 with SMTP id 9so10521172gxk.13
        for <linux-ext4@vger.kernel.org>; Mon, 29 Sep 2008 07:33:01 -0700 (PDT)
In-Reply-To: <20080928210118.GD8711@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Not an assignment actually, but a project.
We are working on open hierarchical storage management, in which we
store files on disks according to different file placement policies.
For eg. if i say that all the important files, like all the employee
database should be in disk 1 and all the songs on disk 2, then we
place them accordingly in different disks.


On Mon, Sep 29, 2008 at 2:31 AM, Theodore Tso <tytso@mit.edu> wrote:
> On Sun, Sep 28, 2008 at 03:49:04PM +0530, Rohit Sharma wrote:
>> Suppose i have a file named abc.txt and i want to specify that
>> all the *.txt files must be allocated between block groups no. 100 -
>> 200 in ext2 fs.
>>
>> Is there a way to do this?
>>
>> can we modify function ext2_new_inode and find_group_orlov for this?
>
> You would have to modify kernel code to do this; the main question
> which comes to mind is *why* would you want to do something like this?
> It seems like an ideal problem set that a professor might give to a
> student, since it would force them to try to get from an inode to the
> pathname used to open the file.  So it seems to be one of these really
> pointless things that isn't particularly useful in real life, except
> for pedagogical purposes.
>
>                                                        - Ted
>

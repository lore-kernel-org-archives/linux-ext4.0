From: Viji V Nair <viji@fedoraproject.org>
Subject: Re: optimising filesystem for many small files
Date: Sun, 18 Oct 2009 15:01:46 +0530
Message-ID: <84c89ac10910180231p202fb5f1r2e192e9ac0b51509@mail.gmail.com>
References: <84c89ac10910162352x5cdeca37icfbf0af2f2325d7c@mail.gmail.com>
	 <4AD9D599.3000306@redhat.com>
	 <84c89ac10910171056i773dfb93wc2e917a086dd8ef0@mail.gmail.com>
	 <20091017222619.GA10074@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>, ext3-users@redhat.com,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f171.google.com ([209.85.216.171]:41633 "EHLO
	mail-px0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbZJRJbl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Oct 2009 05:31:41 -0400
Received: by pxi1 with SMTP id 1so531500pxi.33
        for <linux-ext4@vger.kernel.org>; Sun, 18 Oct 2009 02:31:46 -0700 (PDT)
In-Reply-To: <20091017222619.GA10074@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 18, 2009 at 3:56 AM, Theodore Tso <tytso@mit.edu> wrote:
> On Sat, Oct 17, 2009 at 11:26:04PM +0530, Viji V Nair wrote:
>> these files are not in a single directory, this is a pyramid
>> structure. There are total 15 pyramids and coming down from top to
>> bottom the sub directories and files =A0are multiplied by a factor o=
f 4.
>>
>> The IO is scattered all over!!!! and this is a single disk file syst=
em.
>>
>> Since the python application is creating files, it is creating
>> multiple files to multiple sub directories at a time.
>
> What is the application trying to do, at a high level? =A0Sometimes i=
t's
> not possible to optimize a filesystem against a badly designed
> application. =A0:-(

The application is reading the gis data from a data source and
plotting the map tiles (256x256, png images) for different zoom
levels. The tree output of the first zoom level is as follows

/tiles/00
`-- 000
    `-- 000
        |-- 000
        |   `-- 000
        |       `-- 000
        |           |-- 000.png
        |           `-- 001.png
        |-- 001
        |   `-- 000
        |       `-- 000
        |           |-- 000.png
        |           `-- 001.png
        `-- 002
            `-- 000
                `-- 000
                    |-- 000.png
                    `-- 001.png

in each zoom level the fourth level directories are multiplied by a
factor of four. Also the number of png images are multiplied by the
same number.
>
> It sounds like it is generating files distributed in subdirectories i=
n
> a completely random order. =A0How are the files going to be read
> afterwards? =A0In the order they were created, or some other order
> different from the order in which they were read?

The application which we are using are modified versions of mapnik and
tilecache, these are single threaded so we are running 4 process at a
time. We can say only four images are created at a single point of
time. Some times a single image is taking around 20 sec to create. I
can see lots of system resources are free, memory, processors etc
(these are 4G, 2 x 5420 XEON)

I have checked the delay in the backend data source, it is on a 12Gbps
LAN and no delay at all.

These images are also read in the same manner.

>
> With a sufficiently bad access patterns, there may not be a lot you
> can do, other than (a) throw hardware at the problem, or (b) fix or
> redesign the application to be more intelligent (if possible).
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>

The file system is crated with "-i 1024 -b 1024" for larger inode
number, 50% of the total images are less than 10KB. I have disabled
access time and given a large value to the commit also. Do you have
any other recommendation of the file system creation?

Viji
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

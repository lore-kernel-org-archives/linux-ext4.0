From: Viji V Nair <viji@fedoraproject.org>
Subject: Re: optimising filesystem for many small files
Date: Sun, 18 Oct 2009 22:03:42 +0530
Message-ID: <84c89ac10910180933p3ddb9947ye464a19ba29e4ccc@mail.gmail.com>
References: <84c89ac10910162352x5cdeca37icfbf0af2f2325d7c@mail.gmail.com>
	 <4AD9D599.3000306@redhat.com>
	 <84c89ac10910171056i773dfb93wc2e917a086dd8ef0@mail.gmail.com>
	 <20091017222619.GA10074@mit.edu>
	 <84c89ac10910180231p202fb5f1r2e192e9ac0b51509@mail.gmail.com>
	 <4ADB357B.4030008@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, ext3-users@redhat.com,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f171.google.com ([209.85.216.171]:64111 "EHLO
	mail-px0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbZJRQdi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Oct 2009 12:33:38 -0400
Received: by pxi1 with SMTP id 1so672488pxi.33
        for <linux-ext4@vger.kernel.org>; Sun, 18 Oct 2009 09:33:42 -0700 (PDT)
In-Reply-To: <4ADB357B.4030008@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 18, 2009 at 9:04 PM, Eric Sandeen <sandeen@redhat.com> wrot=
e:
> Viji V Nair wrote:
>>
>> On Sun, Oct 18, 2009 at 3:56 AM, Theodore Tso <tytso@mit.edu> wrote:
>>>
>>> On Sat, Oct 17, 2009 at 11:26:04PM +0530, Viji V Nair wrote:
>>>>
>>>> these files are not in a single directory, this is a pyramid
>>>> structure. There are total 15 pyramids and coming down from top to
>>>> bottom the sub directories and files =A0are multiplied by a factor=
 of 4.
>>>>
>>>> The IO is scattered all over!!!! and this is a single disk file sy=
stem.
>>>>
>>>> Since the python application is creating files, it is creating
>>>> multiple files to multiple sub directories at a time.
>>>
>>> What is the application trying to do, at a high level? =A0Sometimes=
 it's
>>> not possible to optimize a filesystem against a badly designed
>>> application. =A0:-(
>>
>> The application is reading the gis data from a data source and
>> plotting the map tiles (256x256, png images) for different zoom
>> levels. The tree output of the first zoom level is as follows
>>
>> /tiles/00
>> `-- 000
>> =A0 =A0`-- 000
>> =A0 =A0 =A0 =A0|-- 000
>> =A0 =A0 =A0 =A0| =A0 `-- 000
>> =A0 =A0 =A0 =A0| =A0 =A0 =A0 `-- 000
>> =A0 =A0 =A0 =A0| =A0 =A0 =A0 =A0 =A0 |-- 000.png
>> =A0 =A0 =A0 =A0| =A0 =A0 =A0 =A0 =A0 `-- 001.png
>> =A0 =A0 =A0 =A0|-- 001
>> =A0 =A0 =A0 =A0| =A0 `-- 000
>> =A0 =A0 =A0 =A0| =A0 =A0 =A0 `-- 000
>> =A0 =A0 =A0 =A0| =A0 =A0 =A0 =A0 =A0 |-- 000.png
>> =A0 =A0 =A0 =A0| =A0 =A0 =A0 =A0 =A0 `-- 001.png
>> =A0 =A0 =A0 =A0`-- 002
>> =A0 =A0 =A0 =A0 =A0 =A0`-- 000
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0`-- 000
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|-- 000.png
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0`-- 001.png
>>
>> in each zoom level the fourth level directories are multiplied by a
>> factor of four. Also the number of png images are multiplied by the
>> same number.
>>>
>>> It sounds like it is generating files distributed in subdirectories=
 in
>>> a completely random order. =A0How are the files going to be read
>>> afterwards? =A0In the order they were created, or some other order
>>> different from the order in which they were read?
>>
>> The application which we are using are modified versions of mapnik a=
nd
>> tilecache, these are single threaded so we are running 4 process at =
a
>> time. We can say only four images are created at a single point of
>> time. Some times a single image is taking around 20 sec to create. I
>> can see lots of system resources are free, memory, processors etc
>> (these are 4G, 2 x 5420 XEON)
>>
>> I have checked the delay in the backend data source, it is on a 12Gb=
ps
>> LAN and no delay at all.
>
> The delays are almost certainly due to the drive heads seeking like m=
ad as
> they attempt to write data all over the disk; most filesystems are de=
signed
> so that files in subdirectories are kept together, and new subdirecto=
ries
> are placed at relatively distant locations to make room for the files=
 they
> will contain.
>
> In the past I've seen similar applications also slow down due to new =
inode
> searching heuristics in the inode allocator, but that was on ext3 and=
 ext4
> is significantly different in that regard...
>
>> These images are also read in the same manner.
>>
>>> With a sufficiently bad access patterns, there may not be a lot you
>>> can do, other than (a) throw hardware at the problem, or (b) fix or
>>> redesign the application to be more intelligent (if possible).
>>>
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 - Ted
>>>
>>
>> The file system is crated with "-i 1024 -b 1024" for larger inode
>> number, 50% of the total images are less than 10KB. I have disabled
>> access time and given a large value to the commit also. Do you have
>> any other recommendation of the file system creation?
>
> I think you'd do better to change, if possible, how the application b=
ehaves.
>
> I probably don't know enough about the app but rather than:
>
> /tiles/00
> `-- 000
> =A0 =A0`-- 000
> =A0 =A0 =A0 =A0|-- 000
> =A0 =A0 =A0 =A0| =A0 `-- 000
> =A0 =A0 =A0 =A0| =A0 =A0 =A0 `-- 000
> =A0 =A0 =A0 =A0| =A0 =A0 =A0 =A0 =A0 |-- 000.png
> =A0 =A0 =A0 =A0| =A0 =A0 =A0 =A0 =A0 `-- 001.png
>
> could it do:
>
> /tiles/00/000000000000000000.png
> /tiles/00/000000000000000001.png
>
> ...
>
> for example? =A0(or something similar)
>
> -Eric

The tilecache application is creating these directory structure, we
need to change it and our application for a new directory tree.

>
>> Viji
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

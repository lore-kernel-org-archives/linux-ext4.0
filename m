From: pg_ext3@ext3.to.sabi.co.UK (Peter Grandi)
Subject: Re: optimising filesystem for many small files
Date: Sun, 18 Oct 2009 15:15:24 +0100
Message-ID: <19163.8956.421374.35494@tree.ty.sabi.co.uk>
References: <84c89ac10910162352x5cdeca37icfbf0af2f2325d7c@mail.gmail.com>
	<4AD9D599.3000306@redhat.com>
	<84c89ac10910171056i773dfb93wc2e917a086dd8ef0@mail.gmail.com>
	<20091017222619.GA10074@mit.edu>
	<84c89ac10910180231p202fb5f1r2e192e9ac0b51509@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Linux ext4 <linux-ext4@vger.kernel.org>,
	Linux ext3 <ext3-users@RedHat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 82-69-39-138.dsl.in-addr.zen.co.uk ([82.69.39.138]:52225 "EHLO
	ty.sabi.co.UK" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636AbZJROp5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Oct 2009 10:45:57 -0400
In-Reply-To: <84c89ac10910180231p202fb5f1r2e192e9ac0b51509@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>> Hi, System : Fedora 11 x86_64 Current Filesystem: 150G ext4
>>>> (formatted with "-T small" option) Number of files: 50
>>>> Million, 1 to 30K png images We are generating these files
>>>> using a python programme and getting very slow IO
>>>> performance. While generation there in only write, no
>>>> read. After generation there is heavy read and no write.
>>>> I am looking for best practices/recommendation to get a
>>>> better performance.  Any suggestions of the above are
>>>> greatly appreciated.

The first suggestion is to report issues in a less vague way.

Perhaps you are actually getting very good performance, but it is
not sufficient for the needs of your application; or perhaps you
are really getting poor performance, and emoving the cause would
make it sufficient for the needs of your application. But no
information on what is the current and what is the desired
performance is available, and that should have been the first
thing stated.

>>> [ ... ] these files are not in a single directory, this is a
>>> pyramid structure. There are total 15 pyramids and coming down
>>> from top to bottom the sub directories and files=A0are
>>> multiplied by a factor of 4. The IO is scattered all over!!!!
>>> [ ... ]

Is that a surprise? First one creates a marvellously pessimized
data storage scheme, and then "surprise!" IO is totally random
(and it is likely to be somewhat random at the application level
too).

>> [ ... ] What is the application trying to do, at a high level?
>> Sometimes it's not possible to optimize a filesystem against a
>> badly designed application. =A0:-( [ ... ]

> The application is reading the gis data from a data source and
> plotting the map tiles (256x256, png images) for different zoom
> levels. The tree output of the first zoom level is as follows in
> each zoom level the fourth level directories are multiplied by a
> factor of four. Also the number of png images are multiplied by
> the same number. Some times a single image is taking around 20
> sec to create. [ ... ]

Once upon a time in the Land of the Silly Fools some folks wanted
to store many small records, and being silly fools they worried
about complicated nonsense like locality of access, index fanout,
compact representations, caching higher index tree levels, and
studied indexed files and DBMSes; and others who wanted to store
large images with various LODs studied ways to have compact,
progressive representations of those images.

As any really clever programmer and sysadm knows, all those silly
fools wasted a lot of time because it is very easy indeed instead
to just represent large small-record image collections as files
scattered in a many-level directory tree, and LODs as files of
varying size in subdirectories of that tree. :-)

[ ... ]

>> With a sufficiently bad access patterns, there may not be a lot
>> you can do, other than (a) throw hardware at the problem, or
>> (b) fix or redesign the application to be more intelligent (if
>> possible).

"if possible" here is a big understatement. :-)

> The file system is crated with "-i 1024 -b 1024" for larger
> inode number, 50% of the total images are less than 10KB.
> I have disabled access time and given a large value to the
> commit also.

These are likely to be irrelevant or counteproductive, and do not
address the two main issues, the acess pattern profile of the
application and how stunningly pessimized the current setup is.

> Do you have any other recommendation of the file system
> creation?

Get the application and the system redeveloped by some not-clever
programmers and sysadms who come from the Land of the Silly Fools
and thus have heard of indexed files and databases and LOD image
representations and know why silly fools use them. :-)

Since that recommendation is unlikely to happen (turkeys don't
vote for Christmas...), the main alternative is use some kind of
SLC SSD (e.g. recent Intel 160GB one) so as to minimize the impact
of a breathtakingly pessimized design thanks to a storage device
that can do very many more IOP/s than a hard disk. On a flash SSD
I would suggest using 'ext2' (or NILFS2, and I wish that UDF were
in a better state):

  http://www.storagesearch.com/ssd.html
  http://club.cdfreaks.com/f138/ssd-faq-297856/
  http://www.anandtech.com/cpuchipsets/showdoc.aspx?i=3D3607&p=3D4

Actually I would use an SSD even with an indexed file or a DBMS
and a LOD friendly image representation, because while that will
avoid the pessimized 15-layer index tree of directories, even in
the best of cases the app looks like having extremly low locality
of reference for data, and odds are that there will be 1-3 IOPs
per image cess (while probably currently there are many more).

The minor alternative is to use a file system like ReiserFS that
uses index trees internally and handles particularly well file
"tails", and also spread the excitingly pessimized IOP load across
a RAID5 (this application seems one of the only 2 cases where a
RAID5 makes sense), not a single disk. A nice set of low access
time 2.5" SAS drives might be the best choice. But considering the
cost of a flash 160GB SSD today, I'd go for a flash SSD drive (or
a small RAID of those) and a suitable fs.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

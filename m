From: Radek Pazdera <rpazdera@redhat.com>
Subject: Re: [RFC 0/9] ext4: An Auxiliary Tree for the Directory Index
Date: Wed, 19 Jun 2013 14:10:20 +0200
Message-ID: <20130619121020.GA13018@laptop.brq.redhat.com>
References: <1367702922-3236-1-git-send-email-rpazdera@redhat.com>
 <20130616005533.GF29338@dastard>
 <alpine.LFD.2.00.1306171057050.3270@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org,
	kasparek@fit.vutbr.cz
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756566Ab3FSNKv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Jun 2013 09:10:51 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1306171057050.3270@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 17, 2013 at 10:58:35AM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
>On Sun, 16 Jun 2013, Dave Chinner wrote:
>
>> Date: Sun, 16 Jun 2013 10:55:33 +1000
>> From: Dave Chinner <david@fromorbit.com>
>> To: Radek Pazdera <rpazdera@redhat.com>
>> Cc: linux-ext4@vger.kernel.org, lczerner@redhat.com, kasparek@fit.vu=
tbr.cz
>> Subject: Re: [RFC 0/9] ext4: An Auxiliary Tree for the Directory Ind=
ex
>>=20
>> On Sat, May 04, 2013 at 11:28:33PM +0200, Radek Pazdera wrote:
>> > Hello everyone,
>> >=20
>> > I am an university student from Brno /CZE/. I decided to try to op=
timise
>> > the readdir/stat scenario in ext4 as the final project to school. =
I
>> > posted some test results I got few months ago [1].
>> >=20
>> > I tried to implement an additional tree for ext4's directory index
>> > that would be sorted by inode numbers. The tree then would be used
>> > by ext4_readdir() which should lead to substantial increase of
>> > performance of operations that manipulate a whole directory at onc=
e.
>> >=20
>> > The performance increase should be visible especially with large
>> > directories or in case of low memory or cache pressure.
>> >=20
>> > This patch series is what I've got so far. I must say, I originall=
y
>> > thought it would be *much* simpler :).
>> ....
>> > BENCHMARKS
>> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> >=20
>> > I did some benchmarks and compared the performance with ext4/htree=
,
>> > XFS, and btrfs up to 5 000 000 of files in a single directory. Not
>> > all of them are done though (they run for days).
>>=20
>> Just a note that for users that have this sort of workload on XFS,
>> it is generally recommended that they increase the directory block
>> size to 8-16k (from the default of 4k). The saddle point where 8-16k
>> directory blocks tends to perform better than 4k directory blocks is
>> around the 2-3 million file point....
>>=20
>> Further, if you are doing random operations on such directories,
>> then increasing it to the maximum of 64k is recommended. This
>> greatly reduces the IO overhead of directory manipulations by making
>> the trees widers and shallower. i.e. we recommend trading off CPU
>> and memory for lower IO overhead and better layout on disk as it's
>> layout and IO that are the performance limiting factors for large
>> directories. :)

Hi Dave,

Thank you for pointing that out, I was not aware of that. I know that
the 5M tests may be a bit too extreme. I thought it might be interestin=
g
to see what happens.

>> > Full results are available here:
>> >     http://www.stud.fit.vutbr.cz/~xpazde00/soubory/ext4-5M/
>>=20
>> Can you publish the scripts you used so we can try to reproduce
>> your results?
>
>Hi Dave,
>
>IIRC the tests used to generate the results should be found here:
>
>https://github.com/astro-/dir-index-test
>
>however I am not entirely sure whether the github repository is kept
>up-to-date. Radek can you confirm ?

Lukas is right, these are the scripts I used to get the results above
and they're up-to-date.

If you'd like to run the tests, there are some parameters you will
probably need to adjust in the run_tests.sh file. Namely:

DEVICE       - that's the testing device
DROP_OFF_DIR - this is a scratch dir for the copy test, which should
               reside on a separate device
RESULTS_DIR  - this is where you want your graphs to be stored
=46ILESYSTEMS  - ext4, btrfs, jfs or xfs. If you would like to change t=
he
               parameters of mkfs, you can do it here:

               https://github.com/astro-/dir-index-test/blob/master/scr=
ipts/prepfs.sh

=46SIZES       - the size of each file in the directory (if you provide=
 a
               list of values, the tests will be run multiple times wit=
h
               different file sizes)

TEST_CASES   - the readdir-stat and getdents-stat are just isolated
               directory traversals (they are written in C)

               https://github.com/astro-/dir-index-test/blob/master/src=
/readdir-stat.c
               https://github.com/astro-/dir-index-test/blob/master/src=
/getdents-stat.c

               The other tests are here:

               https://github.com/astro-/dir-index-test/tree/master/tes=
ts

DIR_TYPE     - clean or dirty (you will probably be interested in the
               "dirty" type of tests). The difference can be seen here
               (the create_clean_dir and create_dirty_dir functions):
               https://github.com/astro-/dir-index-test/blob/master/scr=
ipts/create_files.py

DIR_SIZES    - you can put a list of values here

To be able to run the tests properly, you need to have gnuplot installe=
d.

If you have any questions or problems, please, let me know :).

Cheers,
Radek

>-Lukas
>
>>=20
>> > I also did some tests on an aged file system (I used the simple 0.=
8
>> > chance to create, 0.2 to delete a file) where the results of ext4
>> > with itree are much better even than xfs, which gets fragmented:
>> >=20
>> >     http://www.stud.fit.vutbr.cz/~xpazde00/soubory/5M-dirty/cp.png
>> >     http://www.stud.fit.vutbr.cz/~xpazde00/soubory/5M-dirty/readdi=
r-stat.png
>>=20
>> This XFS result is of interest to me here - it shouldn't degrade
>> like that, so having the script to be able to reproduce it locally
>> would be helpful to me. Indeed, I posted a simple patch yesterday
>> that significantly improves XFS performance on a similar small file
>> create workload:
>>=20
>> http://marc.info/?l=3Dlinux-fsdevel&m=3D137126465712701&w=3D2
>>=20
>> That writeback plugging change should benefit ext4 as well in these
>> workloads....
>>=20
>> Cheers,
>>=20
>> Dave.
>>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

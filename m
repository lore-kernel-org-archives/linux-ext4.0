From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] libext2fs: reserve exclude bitmap fields in group descriptor
Date: Fri, 16 Sep 2011 09:45:48 +0300
Message-ID: <CAOQ4uxg1W2WQE-SsBKnjNKnwquRUuXPxhYaDbnkMRQNt23jqsA@mail.gmail.com>
References: <CAOQ4uxjydz_6Upm5AUErHct2J0VKSN3-d-XT+Jn=q9BJFWQtaw@mail.gmail.com>
	<20110915131606.GG15782@thunk.org>
	<CAOQ4uxi0Xq89Va_ttTGJGZO342Mpa7HG03DhjhEsfHsubeso7A@mail.gmail.com>
	<F609F599-7286-4E6C-93B2-FEB9F9F5C077@dilger.ca>
	<20110915215759.GG28181@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:48141 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab1IPGpt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Sep 2011 02:45:49 -0400
Received: by wwn22 with SMTP id 22so184192wwn.1
        for <linux-ext4@vger.kernel.org>; Thu, 15 Sep 2011 23:45:48 -0700 (PDT)
In-Reply-To: <20110915215759.GG28181@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 16, 2011 at 12:57 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Thu, Sep 15, 2011 at 01:08:34PM -0600, Andreas Dilger wrote:
>> In that light, why not continue to use an inode to map the exclude b=
itmap
>> blocks, where the bitmap offset is (group * blocksize), instead of
>> explicitly listing all of the blocks in the group descriptor? =A0Thi=
s is
>> how the buddy bitmap works in memory only, but it could be done for =
the
>> exclude bitmap on disk.
>

And this exactly is how the exclude inode works, except only the DIND
block is used
for mapping, just like the resize inode.

> I seem to recall the use of an inode to map the exclude bitmap added =
a
> huge amount of complexity to the snapshot patches. =A0Amir, am I
> remembering this correctly?
>

No, I am not sure this is accurate.
I think after we over viewed the e2fsprogs snapshots patch set, you
has 2 observations:
1. the largest part (in lines of code) of the e2fsprogs snapshot patch =
set
    is related to the exclude inode/bitmap code.
2. it reminded you of resize inode too much and you didn't like that
3. There was also the issue of whether or not to allow the removal of
the exclude inode/bitmap
    and then re-allocation would not be in optimal layout

In retrospect, after Yongqiang has implemented the alternative exclude
bitmap patch set
for e2fsprogs, I can say:
1. The alternative patch set is not smaller
2. It is a lot more elegant and deals with correct layout of exclude
bitmap (next to block bitmap)
3. It will be able to deal with 64bit fs (unlike exclude/resize inode)
and 64bit resize

Yongqiang, do you have anything else to add to the exclude inode vs.
group desc issue?

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

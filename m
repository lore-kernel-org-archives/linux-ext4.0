From: Justin Maggard <jmaggard10@gmail.com>
Subject: Re: >16TB issues
Date: Fri, 28 Aug 2009 13:27:26 -0700
Message-ID: <150c16850908281327g77bd0c5cmda53310d68742263@mail.gmail.com>
References: <20090721192123.GK4231@webber.adilger.int>
	 <20090730222349.GC31141@shell>
	 <150c16850907311824n71e36f66i86b508bc25d0c4bb@mail.gmail.com>
	 <20090811213947.GA11100@shell> <20090811220511.GC31342@mit.edu>
	 <20090812012538.GD11100@shell> <20090812020439.GE31342@mit.edu>
	 <20090812175916.GE11100@shell>
	 <150c16850908271930x277daa95sdea8c34868f2ce36@mail.gmail.com>
	 <20090828124013.GB16732@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Valerie Aurora <vaurora@redhat.com>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	Nick Dokos <nicholas.dokos@hp.com>,
	Julia Lawall <julia@diku.dk>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.216.174]:63893 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbZH1U1Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Aug 2009 16:27:24 -0400
Received: by pxi4 with SMTP id 4so2216540pxi.21
        for <linux-ext4@vger.kernel.org>; Fri, 28 Aug 2009 13:27:26 -0700 (PDT)
In-Reply-To: <20090828124013.GB16732@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 28, 2009 at 5:40 AM, Theodore Tso<tytso@mit.edu> wrote:
> Um, that's interesting. =A0What happens if run fsck.ext4 twice? =A0i.=
e:
>
Here's what happens with an immediate fsck after the first one.
Again, if I don't create the directories, there are no errors.

# fsck.ext4 -C0 -fy /dev/md0
e2fsck 1.41.8 (20-Jul-2009)
One or more block group descriptor checksums are invalid.  Fix? yes

Group descriptor 0 checksum is invalid.  FIXED.
Group descriptor 1 checksum is invalid.  FIXED.
Group descriptor 2 checksum is invalid.  FIXED.
Group descriptor 3 checksum is invalid.  FIXED.
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/md0: 16/365234176 files (0.0% non-contiguous), 23315701/5843746816=
 blocks
# echo $?
0
# fsck.ext4 -C0 -fy /dev/md0
e2fsck 1.41.8 (20-Jul-2009)
One or more block group descriptor checksums are invalid.  Fix? yes

Group descriptor 1 checksum is invalid.  FIXED.
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/md0: 16/365234176 files (0.0% non-contiguous), 23315701/5843746816=
 blocks
# echo $?
0

-Justin
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

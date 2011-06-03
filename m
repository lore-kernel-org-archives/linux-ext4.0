From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Fwd: XFS TESTS: Add Fallocate Punch Hole Test v4 Changes
Date: Fri, 03 Jun 2011 12:15:28 -0700
Message-ID: <4DE932D0.9040808@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



-------- Original Message --------
Subject: XFS TESTS: Add Fallocate Punch Hole Test v4 Changes
Date: Wed, 25 May 2011 19:40:20 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
To: xfs-oss <xfs@oss.sgi.com>

Hi All,

Here is v4 of the punch hole tests.  I've merged in the non over-lapping 
tests from v3 into 252, and I've separated the code paths for punch hole 
and fallocate in the fsx patch.  I've also included the ENOSPC test that 
we used in the ext4 punch hole tests.  Feedback appreciated!  Thx All!

Allison Henderson

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: [XFS Tests Punch Hole 2/3 v3] XFS TESTS: Add Fallocate Punch
 Hole Test Routines
Date: Thu, 19 May 2011 16:36:34 -0700
Message-ID: <4DD5A982.9090907@oracle.com>
References: <4DD43300.6010908@linux.vnet.ibm.com> <20110519013144.GF32466@dastard> <4DD560CF.3040706@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david@fromorbit.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>, Mark Fasheh <mfasheh@suse.com>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:38068 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab1ESXh3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 May 2011 19:37:29 -0400
In-Reply-To: <4DD560CF.3040706@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/19/2011 11:26 AM, Allison Henderson wrote:
> Thx for the all the reviewing on this one.  Im not quite sure I agree that the tests are analogous though.  I did some poking around in xfsprogs which I believe is what test 252 is using to do perform most of its operations.  I found the code where the hole gets punched, but I didnt find any code that does any kind of analyzing to verify that the hole was punched correctly.  Maybe I over looked it?  It kinda looks like the hole gets punched and it just checks the return code (fpunch_f in io/prealloc.c right?).
>

Mark Fasheh wrote a test for the same for ocfs2 that might help. Check it out.

http://oss.oracle.com/git/?p=ocfs2-test.git;a=tree;f=programs/fill_verify_holes;h=0df38895e7ff6e66a9a558f35407699ebb40f790;hb=HEAD


From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: zero out small extents when writing to prealloc	area.
Date: Tue, 04 Mar 2008 23:45:17 -0700
Message-ID: <20080305064517.GB3616@webber.adilger.int>
References: <1204634767-16918-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1204678288.3605.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	tytso@mit.edu, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:47543 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756747AbYCEGpw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Mar 2008 01:45:52 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m256jqa3025955
	for <linux-ext4@vger.kernel.org>; Tue, 4 Mar 2008 22:45:52 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JX800J01W2MMS00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 04 Mar 2008 22:45:52 -0800 (PST)
In-reply-to: <1204678288.3605.15.camel@localhost.localdomain>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 04, 2008  16:51 -0800, Mingming Cao wrote:
> On Tue, 2008-03-04 at 18:16 +0530, Aneesh Kumar K.V wrote:
> > +	/* If extent has less than 2*EXT4_EXT_ZERO_LEN zerout directly */
> > +	if (ee_len <= 2*EXT4_EXT_ZERO_LEN) {
> 
> Hmm, here this is range is extended to 2*EXT4_EXT_ZERO_LEN? I am a
> little more biased to keep the threshold constant as EXT4_EXT_ZERO_LEN
> around all places...

I initially thoguht this also, but it makes sense.  If the extent is
<= 2x EXT4_EXT_ZERO_LEN and it is split anywhere then the resulting
parts will be < EXT4_EXT_ZERO_LEN themselves, unless split is very
close to one edge.  Even then it is better to keep a single initialized
extent instead of 3 different ones.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.


From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Sat, 16 Apr 2011 08:21:28 -0400
Message-ID: <4EEEA16E-1FDB-4430-A372-8F8701196E4C@mit.edu>
References: <20110414102608.GA1678@x4.trippels.de> <20110414120635.GB1678@x4.trippels.de> <20110414140222.GB1679@x4.trippels.de> <4DA70BD3.1070409@draigBrady.com> <4DA717B2.3020305@sandeen.net> <20110414225904.GK21395@dastard> <4DA7836A.5040604@draigBrady.com> <20110415000940.GL21395@dastard> <76FFF648-CA02-494B-A862-566C66A8CB82@dilger.ca> <20110416005040.GP21395@dastard> <E7438588-5C5A-42B9-9B6C-FADF7CAC6D3A@dilger.ca>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Dave Chinner <david@fromorbit.com>,
	=?iso-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>,
	Eric Sandeen <sandeen@sandeen.net>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"coreutils@gnu.org" <coreutils@gnu.org>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	xfs-oss <xfs@oss.sgi.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:50283 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751051Ab1DPMVi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 Apr 2011 08:21:38 -0400
In-Reply-To: <E7438588-5C5A-42B9-9B6C-FADF7CAC6D3A@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Apr 16, 2011, at 1:11 AM, Andreas Dilger wrote:

> In that case, it means cp should just always use FIEMAP_FLAG_SYNC, which is fine. 

Except that if someone is copying a large delay allocated file, it will cause 
the file to immediately snapped to disk, which might not be the greatest
thing in the world.  Christoph is write, SEEK_HOLE and SEEK_DATA are
a much better API for what cp woulld lke to do.  Unfortunately it hasn't
been implemented yet in the VFS...

- Ted
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 0/4] 32/64 bit llseek hashes (v4)
Date: Thu, 8 Dec 2011 16:10:36 -0500
Message-ID: <20111208211036.GE32505@fieldses.org>
References: <20110817095717.1879649.41075.stgit@fsdevel3>
 <4E5D6058.8040805@fastmail.fm>
 <4EBA9551.4000404@redhat.com>
 <4EE0FF93.9060907@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Bernd Schubert <bernd.schubert@fastmail.fm>,
	linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, yong.fan@whamcloud.com,
	adilger@whamcloud.com, "J. Bruce Fields" <bfields@redhat.com>
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fieldses.org ([174.143.236.118]:44142 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab1LHVKl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Dec 2011 16:10:41 -0500
Content-Disposition: inline
In-Reply-To: <4EE0FF93.9060907@itwm.fraunhofer.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 08, 2011 at 07:18:59PM +0100, Bernd Schubert wrote:
> Ted,
> 
> is there anything I can do to get those patched into 3.3?
> The patches still apply in current linux-git.

They appear to solve a real problem for nfsd.  What's holding them up?

--b.

From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/4] Fix filesystem freezing
Date: Thu, 12 Jan 2012 15:48:26 -0500
Message-ID: <20120112204826.GG6626@thunk.org>
References: <1326331253-6497-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	Eric Sandeen <sandeen@sandeen.net>,
	Dave Chinner <dchinner@redhat.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Kamal Mostafa <kamal@canonical.com>,
	Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47600 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755378Ab2ALUsc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jan 2012 15:48:32 -0500
Content-Disposition: inline
In-Reply-To: <1326331253-6497-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 12, 2012 at 02:20:49AM +0100, Jan Kara wrote:
> reproduce deadlocks due to dirty data as well so please test these patches out.
> Thanks. Also review of patches is welcome.

This patch series looks good to me (modulo issues others have already
pointed out).

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

I assume you're going to send this up through Al's vfs tree?

  	 	      	      	      	      - Ted

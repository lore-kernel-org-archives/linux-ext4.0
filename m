From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL] ext4 changes for 4.2-rc1
Date: Thu, 25 Jun 2015 22:19:29 -0400
Message-ID: <20150626021929.GA552@thunk.org>
References: <20150625034626.GA21682@thunk.org>
 <20150625045430.GG14324@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150625045430.GG14324@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

    [ I renamed "ext4_follow_link()" to "ext4_encrypted_follow_link()" in
      the merge resolution, to make it clear that that function is _only_
      used for encrypted symlinks.  The function doesn't actually work for
      non-encrypted symlinks at all, and they use the generic helpers
		                                                   - Linus ]

Thanks, that was on my todo list as a cleanup patch after the merge window closed...

:-)

	     	       	    	      	      - Ted

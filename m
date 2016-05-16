From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/4] ext4: DAX fixes
Date: Mon, 16 May 2016 16:47:31 -0400
Message-ID: <20160516204731.GN7799@thunk.org>
References: <1462959551-28622-1-git-send-email-jack@suse.cz>
 <20160513052419.GD5862@thunk.org>
 <20160513135600.GA2996@thunk.org>
 <20160516093525.GD12026@quack2.suse.cz>
 <20160516142616.GB21714@quack2.suse.cz>
 <20160516150820.GJ7799@thunk.org>
 <CAPcyv4iVQadEC-23B36QX-2=vioVniRB+_tSh6ro+dCHKkQzuA@mail.gmail.com>
 <20160516155950.GF21714@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Williams <dan.j.williams@intel.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-nvdimm <linux-nvdimm@ml01.01.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160516155950.GF21714@quack2.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 16, 2016 at 05:59:50PM +0200, Jan Kara wrote:
> The patch which fixes ext4 behavior is attached. Just that we know what we
> are speaking about... Rebasing all the patches on top of this is trivial
> (git rebase just handles the conflict automatically).

OK, I've added this one-liner to the ext4 tree.  I presume that if git
rebase handles the conflict automatically, git merge should be able to
handle automatically it as well.

					- Ted

From: Vasily Averin <vvs@sw.ru>
Subject: Re: [RFC PATCH ext3/ext4] orphan list corruption due bad inode
Date: Tue, 05 Jun 2007 11:31:10 +0400
Message-ID: <4665113E.5070908@sw.ru>
References: <4663A0CE.102@sw.ru> <20070604190340.dba85bb0.akpm@linux-foundation.org> <4664FE80.4080801@sw.ru> <20070605061315.GA25760@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>, Vasily Averin <vvs@sw.ru>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	devel@openvz.org, linux-ext4@vger.kernel.org,
	Stephen Tweedie <sct@redhat.com>, adilger@clusterfs.com
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1763917AbXFEHbd@vger.kernel.org>
In-Reply-To: <20070605061315.GA25760@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Christoph Hellwig wrote:
> On Tue, Jun 05, 2007 at 10:11:12AM +0400, Vasily Averin wrote:
>>>>  	return d_splice_alias(inode, dentry);
>>>>  }
>>> Seems reasonable.  So this prevents the bad inodes from getting onto the
>>> orphan list in the first place?
>> make_bad_inode() is called from ext3_read_inode() that is called from iget() only.
> 
> Which is artefact of using the read_inode interface.  Please switch from
> iget to iget_locked and you can handle this case without ever inserting the
> "bad" inode into the inode hash.

Sorry, I do not understand your proposal. Could you please explain your idea in
more details?

thank you,
	Vasily Averin

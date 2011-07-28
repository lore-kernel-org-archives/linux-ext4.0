From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] nfsd: vfs_llseek() with O_32BITHASH or O_64BITHASH
Date: Thu, 28 Jul 2011 07:46:59 -0400
Message-ID: <20110728114659.GA13296@infradead.org>
References: <20110727110148.204979.49551.stgit@localhost.localdomain>
 <20110727110259.204979.56782.stgit@localhost.localdomain>
 <20110727210344.GC9066@infradead.org>
 <4E31298B.7050800@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	yong.fan@whamcloud.com, adilger@whamcloud.com, tytso@mit.edu
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4E31298B.7050800@itwm.fraunhofer.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 28, 2011 at 11:19:07AM +0200, Bernd Schubert wrote:
> before I'm going to work further on the patch sets, I have few
> questions first. Could you please help me with that?
> 
> file->f_mode is set in __dentry_open() based on O_ flags.

Or right after dentry_open, before anyone can possibly grab a reference
to the file.  Just do that in nfsd_open based on an NFSD_MAY_ flag.


From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 5/7] ext4: pass -ESHUTDOWN code to jbd2 layer
Date: Thu, 22 Mar 2018 11:26:45 -0400
Message-ID: <20180322152644.GE2852@thunk.org>
References: <20180220023038.19883-1-tytso@mit.edu>
 <20180220023038.19883-6-tytso@mit.edu>
 <20180306171041.mz7qlpeikih6mtlg@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180306171041.mz7qlpeikih6mtlg@quack2.suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Mar 06, 2018 at 06:10:41PM +0100, Jan Kara wrote:
> Is it really correct that once the filesystem gets shutdown you clear the
> previous error from the journal? Because if we hit some real fs corruption,
> the journal gets aborted, and then someone calls ext4_shutdown(), we'd
> clear that error which looks like a bug to me because that shutdown hardly
> fixes the fs corruption...

That's not what the code does.  If journal->j_errno is set, then we
won't clear it, for precisely what concern you've articulated.

      	    	    	      	   	   - Ted

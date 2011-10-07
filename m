From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: [Ext4 Secure Delete 7/7v4] ext4/jbd2: Secure Delete: Secure delete
 journal blocks
Date: Fri, 07 Oct 2011 12:31:02 -0700
Message-ID: <4E8F5376.1050009@oracle.com>
References: <1317971465-8517-1-git-send-email-achender@linux.vnet.ibm.com> <1317971465-8517-8-git-send-email-achender@linux.vnet.ibm.com> <20111007183531.GI12447@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: djwong@us.ibm.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20111007183531.GI12447@tux1.beaverton.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10/07/2011 11:35 AM, Darrick J. Wong wrote:
> Um.... I don't think ext4 should be accessing journal internals.  At a bare
> minimum the stuff that mucks around with jbd2 ought to be in fs/jbd2 and
> the ext4 parts stuffed in a wrapper in ext4_jbd2.[ch], since ocfs2 also uses
> jbd2.

I agree.

> I'm also wondering -- this logical<->  journal block mapping doesn't seem to be
> committed to disk anywhere.  What happens if jbd2 crashes before we get to
> zeroing journal blocks?  Specifically, would the journal recovery code know
> that a given journal block also needs secure deletion?
>
> Here's a counterproposal: What if ext4 told jbd2 which blocks need to be
> securely deleted while ext4 is creating the transactions?  jbd2 could then set
> a JBD2_FLAG_SECURE_DELETE flag in journal_block_tag_t.t_flags (the descriptor
> block), which would tell the recovery and commit code that the associated
> journal block needs secure deletion when processing is complete.  I _think_ you
> could just extend the functions called by ext4_jbd2.c to take a flags
> parameter.  Does this sound better?  Or even sane? :)
>
> (Not sure if ocfs2 cares about secure delete at all.)

It looks like a useful feature. Though I would be wary of wiring this in
the journaling layer. Mainly for performance reasons.

In ocfs2, we log the truncated bits to a node specific system file called
truncate_log. These bits are flushed to the global bitmap periodically
by a queued task. We do this because taking a cluster lock on the global
bitmap is very expensive.

If I were doing this, I would extend this scheme to handle secure deletes.
The queued task would zero out the clusters before clearing the bits
in the global bitmap.

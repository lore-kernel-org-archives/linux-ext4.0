From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 2/3] ext4: Implement subtree ID support for ext4 filesystem
Date: Wed, 11 Jul 2012 19:26:25 +0400
Message-ID: <87vchue2u6.fsf@dmbot.sw.ru>
References: <1341847725-26114-1-git-send-email-dmonakhov@openvz.org> <1341847725-26114-3-git-send-email-dmonakhov@openvz.org> <20120709210439.GB11960@thunk.org> <874npefo7n.fsf@dmbot.sw.ru> <20120711132429.GA10872@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	jack@suse.cz
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120711132429.GA10872@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 11 Jul 2012 09:24:29 -0400, Theodore Ts'o <tytso@mit.edu> wrote:
> On Wed, Jul 11, 2012 at 04:59:24PM +0400, Dmitry Monakhov wrote:
> > 
> > May be it would be better if i describe feature as "Namespace ID"
> > namespaces is well known abstraction in kernel, so misunderstanding
> > shouldn't happen.
> 
> What if we call it a "quota group", with the rules that if a parent
> directory has a quota group, any files or directories created in that
> parent directory will inherit that quota group, and only processes
> with CAP_SYS_ADMIN can change it.
> 
> And then what if we simply make the rule that if an inode has a quota
> group, the quota is charged against two group id's; the group id named
> in inode, and the quota group?
Yes this looks reasonable, the only thing that we should aware of is id
collision. We have to reserve pool numbers to quota group id's.
This can be easily solved by changing disk structure of quota-file
to use u64 on uid.
> 
> That is, do we really need to have a separate namespace for group ids
> and "subtrees" or "namespaces"?  That means we don't have to change
> the userspace quota tools and we can leverage the existing ways people
> are used to managing group quotas.
> 
> 						- Ted
> --
P.S. You probably heard about tragedy in Krimsk due to water flood.
Tonight i'll go Krimsk to help as a volunteer, so i probably will be
out of Internet next 10-12days. Please excuse me, i'll send updated
version right after i'll back to Moscow.
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking
 infrastructure and convert ext4 to use it
Date: Wed, 05 Apr 2017 15:49:52 -0400
Message-ID: <1491421792.18658.20.camel@redhat.com>
References: <1491215318.2724.3.camel@redhat.com>
         <20170403143257.GA30811@bombadil.infradead.org>
         <1491241657.2673.10.camel@redhat.com>
         <20170403191602.GF30811@bombadil.infradead.org>
         <1491250577.2673.20.camel@redhat.com>
         <87h924kh6t.fsf@notabene.neil.brown.name>
         <20170404115358.GH30811@bombadil.infradead.org>
         <1491308268.20445.4.camel@redhat.com>
         <20170404161247.GJ30811@bombadil.infradead.org>
         <1491323146.309.1.camel@redhat.com>
         <20170404170909.GK30811@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: NeilBrown <neilb@suse.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu, jack@suse.cz
To: Matthew Wilcox <willy@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:36046 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752677AbdDETt5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Apr 2017 15:49:57 -0400
Received: by mail-qk0-f181.google.com with SMTP id p22so20634658qka.3
        for <linux-ext4@vger.kernel.org>; Wed, 05 Apr 2017 12:49:56 -0700 (PDT)
In-Reply-To: <20170404170909.GK30811@bombadil.infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2017-04-04 at 10:09 -0700, Matthew Wilcox wrote:
> On Tue, Apr 04, 2017 at 12:25:46PM -0400, Jeff Layton wrote:
> > That said, I think giving more specific errors where we can is useful.
> > When your program is erroring out and writing 'I/O error' to the logs,
> > then how much time will your admins burn before they figure out that it
> > really failed because the filesystem was full?
> 
> df is one of the first things I check ... a few years ago, I also learned
> to check df -i ... ;-)
> 
> Anyway, given the decision to simply report the last error lets us do this
> implementation:
> 
> void filemap_set_wb_error(struct address_space *mapping, int err)
> {
> 	struct inode *inode = mapping->host;
> 	unsigned int wb_err;
> 
> 	if (!err)
> 		return;
> 	/*
> 	 * This should be called with the error code that we want to return
> 	 * on fsync. Thus, it should always be <= 0.
> 	 */
> 	WARN_ON(err > 0 || err < -MAX_ERRNO);
> 
> 	spin_lock(&inode->i_lock);
> 	wb_err = ((mapping->wb_err & ~MAX_ERRNO) + (1 << 12)) | -err;
> 	WRITE_ONCE(mapping->wb_err, wb_err);
> 	spin_unlock(&inode->i_lock);
> }
> 

I like this idea of being able to store arbitrary error codes there.
That should be used judiciously of course, but we already allow
returning arbitrary errors via the ->fsync op anyway.

I'll plan to incorporate something like that into the next set (with
judicious comments and constants).

One question...is the i_lock the right way to protect this? I think we
could do this locklessly too (cmpxchg in a loop, for instance). I'm not
worried about performance here -- it's just nice to be able to call
simple stuff like this without worrying about locking.

> int filemap_report_wb_error(struct file *file)
> {
> 	struct inode *inode = file_inode(file);
> 	unsigned int wb_err = READ_ONCE(mapping->wb_err);
> 
> 	if (file->f_wb_err == wb_err)
> 		return 0;
> 	return -(wb_err & 4095);
> }
> 
> That only gives us 20 bits of counter, but I think that's enough.

2^20 is 1048576, which seems a little small to me.

We may end up bumping the counter on every failed I/O. How fast can we
generate 1M failed I/Os? :)

2^52 however is 4503599627370496 (4Tios or so) ... that might take a
little longer to overflow. Is it worth the cost here to ensure that
this won't occur?

Actually...we could put this field in the inode instead of the mapping.
I know we've traditionally tracked this in the mapping, but is that
required here?

If we put this field in the inode then perhaps we can union it with
something and mitigate the cost of a larger counter...maybe in the
i_pipe union? I don't think S_ISREG inodes use anything in there, do
they?
-- 
Jeff Layton <jlayton@redhat.com>

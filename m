From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 3/5] ext4: Implement project ID support for ext4 filesystem
Date: Fri, 12 Mar 2010 12:32:09 +0300
Message-ID: <87pr39evhi.fsf@openvz.org>
References: <1267727677-11956-1-git-send-email-dmonakhov@openvz.org>
	<1267727677-11956-2-git-send-email-dmonakhov@openvz.org>
	<1267727677-11956-3-git-send-email-dmonakhov@openvz.org>
	<1267727677-11956-4-git-send-email-dmonakhov@openvz.org>
	<20100311120623.GC4706@infradead.org> <877hpjj88k.fsf@openvz.org>
	<B4AAD310-8A75-43C8-989E-616CFACFB7A9@sun.com>
	<20100311220133.GL1497@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100311220133.GL1497@thunk.org> (tytso@mit.edu's message of
	"Thu, 11 Mar 2010 17:01:33 -0500")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

tytso@mit.edu writes:

> On Thu, Mar 11, 2010 at 12:54:46PM -0700, Andreas Dilger wrote:
>> A second possibility (if there is really no desire to have more than
>> a single project ID per inode) is to add a field to the "large"
>> inode for ext4, though that doesn't help filesystems that were not
>> formatted that way, and it also consumes space in all inodes even if
>> this feature is not used.
>
> The big question that I'm still uncertain about is how often are
> people going to be using this feature, and how many project ID's do we
> really need?  I know Dimitry believes this is going to be the greatest
> thing since sliced bread, but even for people running virtualization,
> I'm not sure how many folks really will consider it critical.
Most of our customers (hosting providers) use quota, otherwise
it is impossible to restrict disk usage. Currently they have to
perform full quotecheck after power failure. Which result in huge
service down time. If we able to use journalled quota all problems
will be solved.
Also NFS people was interesting in projectid feature. They want to
use it for creating safe file-handles.
http://marc.info/?l=linux-fsdevel&m=126634832431306&w=2
In fact the projectid feature is not intrusive (except an isolation part)
it is even much simpler than ACL.
>
> I'd be a bit more willing to give the last 16-bit field for the
> project ID, but otherwise, I think using a 32-bit field in the large
> inode might be the better compromise if we don't like the xattr
> approach.
IMHO one 32-bit value in xattr it the best solution. Because it is
stored in inode's in_body xattr.And how we store it via update_inode
or xattr_set is not really important.
Another plus is that we are able to support all existing filesystems
without any problems even if they have 128-bit inodes.
>
> Of course, I'm willing to be convinced otherwise with some sound
> technical arguments.  (Or beer; beer is good too.  :-)
I've attached two mega-liters of beer. Feel free drink the attachment :)

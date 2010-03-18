From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 3/5] ext4: Implement project ID support for ext4 filesystem
Date: Thu, 18 Mar 2010 15:25:00 -0600
Message-ID: <41219796-D9F2-4292-9284-E8D266EB3532@sun.com>
References: <1268920970-9061-1-git-send-email-dmonakhov@openvz.org>
 <1268920970-9061-2-git-send-email-dmonakhov@openvz.org>
 <1268920970-9061-3-git-send-email-dmonakhov@openvz.org>
 <1268920970-9061-4-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	tytso@mit.edu, hch@infradead.org, jack@suse.cz,
	david@fromorbit.com, viro@ZenIV.linux.org.uk, xemul@openvz.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <1268920970-9061-4-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2010-03-18, at 08:02, Dmitry Monakhov wrote:
> * Disk layout
>  Project id is stored on disk inside xattr usually inside ibody.
>  Xattr is used only as a data storage, It has not user visible xattr
>  interface.
>
> * User interface
>  Project id is accessible via generic xattr interface  
> "system.project_id"
>
> +#define EXT4_XATTR_INDEX_PROJECT_ID	        7

If you are making this attribute available to userspace via  
system.project_id, doesn't it make sense to store it on disk as  
system.project_id also (i.e. in the "system" namespace)?

Alternately, the "trusted" namespace is already intended for use as  
"accessible only by root/kernel" semantics if this is what you are  
trying to achieve.

I'm also with the statement "It has not user visible xattr interface"  
yet you also write "Project id is accessible via generic xattr  
interface".  Why bother having this complexity when you are free to  
make the two identical?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.


From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC] fadvise: add more flags to provide a hint for block
 allocation
Date: Tue, 6 Mar 2012 21:30:55 +0800
Message-ID: <20120306133054.GA24695@gmail.com>
References: <20120305125029.GA5121@gmail.com>
 <4F55189B.4080507@oracle.com>
 <20120306023505.GA7728@gmail.com>
 <4F5591DB.4060807@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Sunil Mushran <sunil.mushran@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F5591DB.4060807@oracle.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Mar 05, 2012 at 08:26:03PM -0800, Sunil Mushran wrote:
> On 3/5/2012 6:35 PM, Zheng Liu wrote:
> >No, _RANDOM means that file system doesn't need to try its best to find
> >a proper position to allocate some blocks for this file.  Furthermore,
> >currently random IOs seem that they are not obviously slower than
> >sequential IOs in Flash/SSD device.  For example, when users know a file
> >that is accessed infrequently, they can put this file in a corner, such
> >as in some discontinuously blocks.  Then sequential blocks are reserved
> >for the file that needs to be accessed frequently and users can obtain
> >the better performance.
> 
> Then FADV_ALLOC_HOT_REGION and FADV_ALLOC_COLD_REGION are
> probably better terms.

Make sense to me. Thanks a lot. ;-)

Regards,
Zheng

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

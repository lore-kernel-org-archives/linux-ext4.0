From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 1/2] ext4: Delete an error message for a failed memory
 allocation in ext4_multi_mount_protect()
Date: Thu, 24 Aug 2017 22:16:45 +0300
Message-ID: <20170824191645.ha3bw5n24lqcpxd7@mwanda>
References: <ca49a6dc-f2ee-d427-5f16-052706277b38@users.sourceforge.net>
 <5bf432ae-398d-718c-8105-3092a240a8ef@users.sourceforge.net>
 <b21f6c3d-2cad-3f72-f410-f608ea5f4cea@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: SF Markus Elfring <elfring@users.sourceforge.net>,
        linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Theodore Ts'o" <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: sandeen@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b21f6c3d-2cad-3f72-f410-f608ea5f4cea@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Aug 19, 2017 at 12:08:29PM -0500, Eric Sandeen wrote:
> On 8/19/17 6:47 AM, SF Markus Elfring wrote:
> > From: Markus Elfring <elfring@users.sourceforge.net>
> > Date: Sat, 19 Aug 2017 13:04:50 +0200
> > 
> > Omit an extra message for a memory allocation failure in this function.
> 
> I might be dense, but what makes this message "extra?"
> 
> (I suppose kmalloc squawks too if it fails, but is Coccinelle
> now warning about explicit memory allocation failure warnings?)
> 

Yeah...  Checkpatch complains that the kmalloc squawks is enough.
"WARNING: Possible unnecessary 'out of memory' message".  This
allocation is small so it's guaranteed to succeed in current kernels.

regards,
dan carpenter

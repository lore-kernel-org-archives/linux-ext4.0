From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Improve a size determination in two functions
Date: Thu, 24 Aug 2017 13:50:39 -0400
Message-ID: <20170824175039.jc6m6pjb5ar6lozm@thunk.org>
References: <ca49a6dc-f2ee-d427-5f16-052706277b38@users.sourceforge.net>
 <c1941b22-bdab-fccf-06e2-2f9fc50daec1@users.sourceforge.net>
 <0d7fe1c1-f1f4-3c2f-0e2a-4c8545947714@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: SF Markus Elfring <elfring@users.sourceforge.net>,
        linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: sandeen@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0d7fe1c1-f1f4-3c2f-0e2a-4c8545947714@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Aug 19, 2017 at 08:49:20PM -0500, Eric Sandeen wrote:
> On 8/19/17 6:48 AM, SF Markus Elfring wrote:
> > From: Markus Elfring <elfring@users.sourceforge.net>
> > Date: Sat, 19 Aug 2017 13:14:26 +0200
> > 
> > Replace the specification of data structures by pointer dereferences
> > as the parameter for the operator "sizeof" to make the corresponding size
> > determination a bit safer according to the Linux coding style convention.
> > 
> > This issue was detected by using the Coccinelle software.
> > 
> > Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> 
> Looks good,
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

					- Ted

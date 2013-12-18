From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 26/74] libss: fix memory handling errors
Date: Wed, 18 Dec 2013 14:23:10 -0800
Message-ID: <20131218222310.GB25946@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012115.30655.51030.stgit@birch.djwong.org>
 <52B0840F.40407@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33297 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab3LRWXZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Dec 2013 17:23:25 -0500
Content-Disposition: inline
In-Reply-To: <52B0840F.40407@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 17, 2013 at 11:04:15AM -0600, Eric Sandeen wrote:
> On 12/10/13, 7:21 PM, Darrick J. Wong wrote:
> > Fix memory allocation calculations and check for NULL pointer returns.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  lib/ss/invocation.c  |    5 +++++
> >  lib/ss/parse.c       |    4 ++++
> >  lib/ss/request_tbl.c |    2 +-
> >  3 files changed, 10 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/lib/ss/invocation.c b/lib/ss/invocation.c
> > index a711050..08b66f2 100644
> > --- a/lib/ss/invocation.c
> > +++ b/lib/ss/invocation.c
> > @@ -20,6 +20,7 @@
> >  #ifdef HAVE_DLOPEN
> >  #include <dlfcn.h>
> >  #endif
> > +#include <errno.h>
> >  
> >  int ss_create_invocation(subsystem_name, version_string, info_ptr,
> >  			 request_table_ptr, code_ptr)
> > @@ -46,6 +47,10 @@ int ss_create_invocation(subsystem_name, version_string, info_ptr,
> >  		;
> >  	table = (ss_data **) realloc((char *)table,
> >  				     ((unsigned)sci_idx+2)*size);
> > +	if (table == NULL) {
> > +		*code_ptr = errno;
> > +		return 0;
> > +	}
> 
> According to coverity CID 295143, this leaks "new_table"
> 
> Just a free() before return would suffice I think.

All right, I'll send out a couple of cleanup patches in a bit.

--D
> 
> Thanks,
> -Eric
> 

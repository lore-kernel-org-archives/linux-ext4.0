From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] obsolete libcom-err for SuSE e2fsprogs
Date: Wed, 19 Sep 2007 20:41:20 -0500
Message-ID: <46F1CFC0.3070801@redhat.com>
References: <20070919061404.GA1628@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbXITBlZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Sep 2007 21:41:25 -0400
In-Reply-To: <20070919061404.GA1628@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> It isn't possible to build an e2fsprogs via "make rpm" on SuSE and have it
> install cleanly, because they split out some of the libraries into separate
> packages.
> 
> We've got the current patch to the .spec file, but I'm open to discussion
> if it is more desirable to change the .spec to continue to build separate
> RPMs (though that is more of a distribution hassle and might need major
> changes in the .spec file).
> 

FWIW, I also have an RFE assigned to me for RHEL/Fedora to split up our
e2fsprogs packages for libcom_err and libuuid... since many
non-filesystem things now require them.   So, this is sort of going in
the opposite direction.  :)

Any idea how many distros already split it out?

-Eric

> Index: e2fsprogs-1.40.2/e2fsprogs.spec.in
> ===================================================================
> --- e2fsprogs-1.40.2.orig/e2fsprogs.spec.in
> +++ e2fsprogs-1.40.2/e2fsprogs.spec.in
> @@ -13,6 +13,10 @@
>  Url: http://e2fsprogs.sourceforge.net/
>  Prereq: /sbin/ldconfig
>  BuildRoot: %{_tmppath}/%{name}-root
> +%if %{_vendor} == "suse"
> +Obsoletes: libcom_err < %{version}
> +Provides: libcom_err = %{version}
> +%endif
>  
>  %description
>  The e2fsprogs package contains a number of utilities for creating,
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

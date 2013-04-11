From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/2 v2] ext4: move ext4_ind_migrate() into migrate.c
Date: Thu, 11 Apr 2013 09:54:41 +0400
Message-ID: <87k3o94noe.fsf@openvz.org>
References: <1365506687-9216-1-git-send-email-lczerner@redhat.com> <20130411035826.GA18878@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: linux-ext4@vger.kernel.org, gnehzuil.liu@gmail.com
To: Theodore Ts'o <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:53764 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab3DKFyr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Apr 2013 01:54:47 -0400
Received: by mail-la0-f41.google.com with SMTP id er20so1134879lab.14
        for <linux-ext4@vger.kernel.org>; Wed, 10 Apr 2013 22:54:45 -0700 (PDT)
In-Reply-To: <20130411035826.GA18878@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

On Wed, 10 Apr 2013 23:58:26 -0400, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Apr 09, 2013 at 01:24:46PM +0200, Lukas Czerner wrote:
> > Move ext4_ind_migrate() into migrate.c file since it makes much more
> > sense and ext4_ext_migrate() is there as well.
> > 
> > Also fix tiny style problem - add spaces around "=" in "i=0".
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> 
> I had to regenerate this patch since ext4_ind_migrate has been changed
> by other patches in the ext4 patch queue, but it's applied now.
You have placed it in to wrong position, Obviously check should be performed before
journal_start()

--=-=-=
Content-Type: application/octet-stream
Content-Disposition: inline; filename=fix
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2ZzL2V4dDQvbWlncmF0ZS5jIGIvZnMvZXh0NC9taWdyYXRlLmMKaW5kZXgg
OGQ2NDA2Ny4uODA1MjA3MCAxMDA2NDQKLS0tIGEvZnMvZXh0NC9taWdyYXRlLmMKKysrIGIvZnMv
ZXh0NC9taWdyYXRlLmMKQEAgLTYyNSwxMyArNjI1LDE0IEBAIGludCBleHQ0X2luZF9taWdyYXRl
KHN0cnVjdCBpbm9kZSAqaW5vZGUpCiAJICAgICghZXh0NF90ZXN0X2lub2RlX2ZsYWcoaW5vZGUs
IEVYVDRfSU5PREVfRVhURU5UUykpKQogCQlyZXR1cm4gLUVJTlZBTDsKIAorCWlmIChFWFQ0X0hB
U19ST19DT01QQVRfRkVBVFVSRShpbm9kZS0+aV9zYiwKKwkJCQkgICAgICAgRVhUNF9GRUFUVVJF
X1JPX0NPTVBBVF9CSUdBTExPQykpCisJCXJldHVybiAtRU9QTk9UU1VQUDsKKwogCWhhbmRsZSA9
IGV4dDRfam91cm5hbF9zdGFydChpbm9kZSwgRVhUNF9IVF9NSUdSQVRFLCAxKTsKIAlpZiAoSVNf
RVJSKGhhbmRsZSkpCiAJCXJldHVybiBQVFJfRVJSKGhhbmRsZSk7CiAKLQlpZiAoRVhUNF9IQVNf
Uk9fQ09NUEFUX0ZFQVRVUkUoaW5vZGUtPmlfc2IsCi0JCQkJICAgICAgIEVYVDRfRkVBVFVSRV9S
T19DT01QQVRfQklHQUxMT0MpKQotCQlyZXR1cm4gLUVPUE5PVFNVUFA7CiAKIAlkb3duX3dyaXRl
KCZFWFQ0X0koaW5vZGUpLT5pX2RhdGFfc2VtKTsKIAlyZXQgPSBleHQ0X2V4dF9jaGVja19pbm9k
ZShpbm9kZSk7Cg==
--=-=-=


> 
>    	 	    	     	   - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=--

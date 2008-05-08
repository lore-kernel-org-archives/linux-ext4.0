From: Eric Sandeen <sandeen@redhat.com>
Subject: commit a4b69b7f1809898c87bdc11502ca258a8f16a220 breaks parallel builds
Date: Wed, 07 May 2008 21:58:03 -0500
Message-ID: <48226C3B.5060007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754883AbYEHC6G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 May 2008 22:58:06 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

	CC unpack.c
	CC unparse.c
	CC uuid_time.c
	GEN_LIB libuuid.a
	GEN_LIB ../../lib/libuuid.a
/bin/ln: creating hard link `../../../lib/libuuid.a' to
`../../lib/libuuid.a': No such file or directory
make[2]: *** [../../lib/libuuid.a] Error 1
make[2]: Leaving directory `/tmp/e2fsprogs-1.41/lib/uuid'
make[1]: *** [all-libs-recursive] Error 1
make[1]: Leaving directory `/tmp/e2fsprogs-1.41'
make: *** [all] Error 2


I tried looking into this, but I'm at a bit of a loss as to what the
change was trying to do, so not sure how to fix it... but from
e2fsprogs/lib/uuid/ it would appear that the addition of
$(LIB)/$(LIBRARY).a here has got us backing up one ".." too far :)

$(LIB)/$(LIBRARY).a $(LIBRARY).a: $(OBJS)
        @echo " GEN_LIB $@"
        @(if test -r $@; then $(RM) -f $@.bak && $(MV) $@ $@.bak; fi)
        @$(ARGEN) $@ $(OBJS)
        -@$(RANLIB) $@
        @$(RM) -f ../$@
        @$(LN) $@ ../$@



-Eric

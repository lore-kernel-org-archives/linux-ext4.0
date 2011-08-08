From: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Subject: [PATCH 3/4] RFC: Remove check for a 32-bit cookie in nfsd4_readdir()
Date: Mon, 08 Aug 2011 17:38:08 +0200
Message-ID: <20110808153808.1872437.85162.stgit@fsdevel3>
References: <20110808153432.1872437.85783.stgit@fsdevel3>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, yong.fan-KloliPT79xf2eFz/2MeuCQ@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, adilger-KloliPT79xf2eFz/2MeuCQ@public.gmane.org
To: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110808153432.1872437.85783.stgit@fsdevel3>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Fan Yong <yong.fan-KloliPT79xf2eFz/2MeuCQ@public.gmane.org> noticed setting
FMODE_32bithash wouldn't work with nfsd v4, as
nfsd4_readdir() checks for 32 bit cookies. However, according to RFC 3530
cookies have a 64 bit type and cookies are also defined as u64 in
'struct nfsd4_readdir'. So remove the test for >32-bit values.

Signed-off-by: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
---
 fs/nfsd/nfs4proc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index e807776..9bf0a66 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -691,7 +691,7 @@ nfsd4_readdir(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	readdir->rd_bmval[1] &= nfsd_suppattrs1(cstate->minorversion);
 	readdir->rd_bmval[2] &= nfsd_suppattrs2(cstate->minorversion);
 
-	if ((cookie > ~(u32)0) || (cookie == 1) || (cookie == 2) ||
+	if ((cookie == 1) || (cookie == 2) ||
 	    (cookie == 0 && memcmp(readdir->rd_verf.data, zeroverf.data, NFS4_VERIFIER_SIZE)))
 		return nfserr_bad_cookie;
 

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

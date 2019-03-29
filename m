Return-Path: <SRS0=q+9q=SA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CB45C43381
	for <linux-ext4@archiver.kernel.org>; Fri, 29 Mar 2019 07:58:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFD912183E
	for <linux-ext4@archiver.kernel.org>; Fri, 29 Mar 2019 07:58:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ZryUbLnm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbfC2H5z (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 29 Mar 2019 03:57:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:21991 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729037AbfC2H5x (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Mar 2019 03:57:53 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20190329075750epoutp0270df5fdeeffc9ff7dca52ed6838607bf~QXvNkw8WY0250102501epoutp02p;
        Fri, 29 Mar 2019 07:57:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20190329075750epoutp0270df5fdeeffc9ff7dca52ed6838607bf~QXvNkw8WY0250102501epoutp02p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1553846270;
        bh=GFd2cqqQm4KEQ7WGWfLlMJoZlKkcBBpbm5t3n+981Ec=;
        h=From:To:Cc:Subject:Date:In-reply-to:References:From;
        b=ZryUbLnmcpdZknCRb6RPVfOEezZtXNQI5cg0oVbGHAra62cNtQgisWqZW+IQqnC8n
         wn65PAkEd25JHCKMGmG37csvSSkpKM/VogQZv1EXL1f0eZDlKNhD3oqSVyDg7KVWDg
         kSNXL/5o2wyCPvl4mZPBQFpLN6bzibI/FTpm0cSA=
Received: from epsmges2p4.samsung.com (unknown [182.195.42.72]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20190329075750epcas2p2e2852ebf4eef202afe7a9f9c8ac48529~QXvNMZfkZ2644326443epcas2p22;
        Fri, 29 Mar 2019 07:57:50 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        75.F1.04207.EFFCD9C5; Fri, 29 Mar 2019 16:57:50 +0900 (KST)
Received: from epsmgms2p2new.samsung.com (unknown [182.195.42.143]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20190329075749epcas2p22b85cbdbb7ccb4f7f3ecf69b84f75dc9~QXvMgyc711454914549epcas2p2M;
        Fri, 29 Mar 2019 07:57:49 +0000 (GMT)
X-AuditID: b6c32a48-6a1ff7000000106f-34-5c9dcffefa1b
Received: from epmmp1.local.host ( [203.254.227.16]) by
        epsmgms2p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EC.CF.03620.DFFCD9C5; Fri, 29 Mar 2019 16:57:49 +0900 (KST)
Received: from test-PowerEdge-R720.sa.corp.samsungelectronics.net
        ([107.108.221.212]) by mmp1.samsung.com (Oracle Communications Messaging
        Server 7.0.5.31.0 64bit (built May  5 2014)) with ESMTPA id
        <0PP40008VBFTTN20@mmp1.samsung.com>; Fri, 29 Mar 2019 16:57:49 +0900 (KST)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Cc:     axboe@fb.com, prakash.v@samsung.com, anshul@samsung.com,
        joshiiitr@gmail.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v3 3/7] block: add write-hint to stream-id conversion
Date:   Fri, 29 Mar 2019 13:23:48 +0530
Message-id: <1553846032-4451-4-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-reply-to: <1553846032-4451-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsWy7bCmue6/83NjDBZ/lLD4PX0Kq8X/PcfY
        LI7+f8tmcf7tYSaLvbe0LWbOu8NmsWfvSRaLy7vmsFnMX/aU3eLKlEXMDlweE5vfsXvsnHWX
        3WPzknqPvi2rGD0+b5ILYI3isklJzcksSy3St0vgypj49QZTwTG+ikfLNrE0MP7k7mLk5JAQ
        MJG4OWUeUxcjF4eQwA5Gif2310A53xklfs7fyQJTtWDlMqjEbkaJb4cWsEI405kkdv6eDuRw
        cLAJaEpcmFwKEhcRmMMosWzfNGaQbmaBcom/U64ygtjCAq4SL3YuZQOxWQRUJabf/MQOYvMK
        OEnsOLiQEWKbnMTNc51gvZwCzhIfrzezgAyVEFjCJrH4+Uc2iCIXiYmnu6HOk5Z4tmojVHOx
        xK87R5khGjoYJa43zIQqspe4uOcvE8RFfBIdh/+yg1wtIcAr0dEmBGF6SOw66ADx2DRGiVmN
        H9gnMEosYGRYxSiWWlCcm55abFRgolecmFtcmpeul5yfu4kRHIFaHjsYD5zzOcQowMGoxMP7
        YfecGCHWxLLiytxDjBIczEoivIHn5sYI8aYkVlalFuXHF5XmpBYfYpTmYFES530oPTdaSCA9
        sSQ1OzW1ILUIJsvEwSnVwNgXf93E4qfHK6XX+zvFzy4/Vm27f2J8YOanypl5F8+a33Hs0nXp
        CchdsESVzfG17vuv3R+6J/ky7ZmdMGfS8ejDbAZ/Lr1UKex1TP1w1qhgns/xs/srkk40LE1o
        4gtLPXetcolGdLTjTZcDws+Fo2zVju9asVqhJFpU0u3txaYns5T3PCg95KnEUpyRaKjFXFSc
        CACyz1isvAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsVy+t9jAd2/5+fGGLxdoWnxe/oUVov/e46x
        WRz9/5bN4vzbw0wWe29pW8ycd4fNYs/ekywWl3fNYbOYv+wpu8WVKYuYHbg8Jja/Y/fYOesu
        u8fmJfUefVtWMXp83iQXwBrFZZOSmpNZllqkb5fAlTHx6w2mgmN8FY+WbWJpYPzJ3cXIySEh
        YCKxYOUyJhBbSGAno0TnZ9cuRi4geyaTxLXlexm7GDk42AQ0JS5MLgWJiwjMYZTo2b2eFSTO
        LFAuMWUTJ0ivsICrxIudS9lAbBYBVYnpNz+xg9i8Ak4SOw4uZITYJSdx81wnM4jNKeAs8fF6
        MwvEXieJtfcb2Ccw8ixgZFjFKJlaUJybnltsVGCUl1quV5yYW1yal66XnJ+7iREYXNsOa/Xv
        YHy8JP4QowAHoxIP74ydc2KEWBPLiitzDzFKcDArifAGnpsbI8SbklhZlVqUH19UmpNafIhR
        moNFSZyXP/9YpJBAemJJanZqakFqEUyWiYNTqoFx1QxWBpkfQeKd185kytgWLji5oPKn5Dfe
        EH+TRb+son/YurnPvXE2au69tIzuhHoba+6YppKilyZFdm/PVrRGVqrNaX4aZTKx9At/b8P2
        LYx23GaTD+nHlgfu2dFtFeuw7sfWHVbPvms8qNGO9z+q0iTvuUqLb/LfGcF7z31QmLrS+PWO
        b81KLMUZiYZazEXFiQB9ziQhKgIAAA==
X-CMS-MailID: 20190329075749epcas2p22b85cbdbb7ccb4f7f3ecf69b84f75dc9
CMS-TYPE: 102P
X-CMS-RootMailID: 20190329075749epcas2p22b85cbdbb7ccb4f7f3ecf69b84f75dc9
References: <1553846032-4451-1-git-send-email-joshi.k@samsung.com>
        <CGME20190329075749epcas2p22b85cbdbb7ccb4f7f3ecf69b84f75dc9@epcas2p2.samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Earlier this conversion was done by driver (nvme). Current conversion
is of the form "streamid = write-hint - 1", for both user and kernel
streams (note that existing infra takes care that user-streams do not
bump into kernel ones). Conversion takes stream limit (maintained in
request queue) into account. Write-hints beyond the queue-limit turn
to 0.
New field 'streamid' has been added in request. While 'write-hint' field
continues to exist. It keeps original value passed from upper layer, and
used during merging checks.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/blk-core.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3c5f61c..c86daed 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -727,6 +727,25 @@ bool blk_attempt_plug_merge(struct request_queue *q, struct bio *bio,
 	return false;
 }
 
+enum rw_hint blk_write_hint_to_streamid(struct request *req,
+				        struct bio *bio)
+{
+	enum rw_hint streamid, nr_streams;
+	struct request_queue *q = req->q;
+	nr_streams = q->limits.nr_streams;
+
+	streamid = bio->bi_write_hint;
+	if (!nr_streams || streamid == WRITE_LIFE_NOT_SET ||
+	    streamid == WRITE_LIFE_NONE)
+		streamid = 0;
+	else {
+		--streamid;
+		if(streamid > nr_streams)
+			streamid = 0;
+	}
+	return streamid;
+}
+
 void blk_init_request_from_bio(struct request *req, struct bio *bio)
 {
 	if (bio->bi_opf & REQ_RAHEAD)
@@ -735,6 +754,7 @@ void blk_init_request_from_bio(struct request *req, struct bio *bio)
 	req->__sector = bio->bi_iter.bi_sector;
 	req->ioprio = bio_prio(bio);
 	req->write_hint = bio->bi_write_hint;
+	req->streamid = blk_write_hint_to_streamid(req, bio);
 	blk_rq_bio_prep(req->q, req, bio);
 }
 EXPORT_SYMBOL_GPL(blk_init_request_from_bio);
-- 
2.7.4


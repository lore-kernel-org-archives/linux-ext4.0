Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.139.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794104392;
	b=0lfC2qblTy7tgovKP2qhxUNKIJ8GdzIr72VVkQg111Y9a5dn1TSIZUEsYR3zWhKIyYS+
	 tf0RRhH240WliFNGQAh7s+ZZ0+gj/VzhxdVQsEcxDs4pOZDJ3pcktzyLkXNkCtW0nXCPI
	 x1aDFYtgTQA+CYsnwKCgiwtMLXPanlusM/rnwOV7XsVVBz3WmBROCJMJv1lIVXdTGA7lf
	 5ycenneHKupg8bWZup91Ecfk30+JoiP7d1G3dvRZXddqMy8CajuGVo5peTmk2h7cP3bIs
	 G+EGZeoK0G78esrvMQ4EltKDaDnKQUquBFY00rzHpsK9BCyPf2/WVbZ3X3pVSYXI/gA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794104392;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:
	 Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=whgMGO08w0bti6oHmDssbLwFbA/tph+QoSDdsYvM5SQ=;
	b=HOAjhgaiM+Ez+tpK/9ZRYnijduS9d+NPc+S0Wf33kFMZkk4P1gJr/nHcqil5y1UyvRg2
	 tP0pFCc8D61b8H8YiUhscV9MbJ8YtHBmtRzYJxfmpnOY0kLWI2f/m3lL4hQ3HERKtOyxL
	 fsZnwOVae0KpZUKgy8HFAk79v6KFDfE+5mN9PdAwTnYHo8Z9e4q4IKVfUlg+JCAXZL+3l
	 vKo9Rw6H3rrO3VA67jbMBtGRAVVaD3WGa09QagYYf095dfbUEhm87sgFe5PFfdyvNcP5K
	 f7PJ3vwEcE19Fe5AkFrlo5MdlgU3zkbWR1Z6MVs+l2447kEguRat6rkh495+co0ziLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=columbia.edu;
	spf=pass smtp.mailfrom=columbia.edu;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=TSHvCuHl;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=c2W59vAp;
	arc=none smtp.remote-ip=148.163.139.74
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C19B606A31C
	for <linux-ext4@vger.kernel.org>; Sun,  8 Nov 2026 02:19:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2C19B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=TSHvCuHl;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=c2W59vAp
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A7NbX2Z1730773
	for <linux-ext4@vger.kernel.org>; Sat, 7 Nov 2026 21:19:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=whgMGO08w0bti6oHmDssbLwFbA
	/tph+QoSDdsYvM5SQ=; b=TSHvCuHluZLbe+ARxX/LUHN9fXLeiN+Dn+3bv/W8/N
	jkFc1Tcktu7NR91Ohrw/u/3263BeXycQ6Tp/i/A6SI+4CBG4lKx3igHjrPc0d/bu
	N1uZInkHRxuWTnaXuDvoZoq9funBIhsMBnTVtxhhEdh2U9nkDv1QUb5HaxfQjCQO
	sAJ9LPrWgYNbxXPCo1LiIp3dKENcrk8yNOp7VO4zxGICCBtM17MBI0w5B72xF7ku
	wRenwNaClKmT9TvIYgC2qaIMQnjBNOa7j1DYdTUkPAJhrkJHtq+Wya2CCOLlDNhn
	Wcl4Ujoz5Dy0pDALyd9luwkY9J4hhLU1ARouoWdNUVVg==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4ht0ur3nba-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Sat, 07 Nov 2026 21:19:43 -0500 (EST)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-91e8b51c11dso1817716d6.2
        for <linux-ext4@vger.kernel.org>; Sat, 07 Nov 2026 18:19:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794104383; x=1794709183; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=whgMGO08w0bti6oHmDssbLwFbA/tph+QoSDdsYvM5SQ=;
        b=c2W59vAp8vrzW4Kf8YZnsNQG0BQg0Yn2OhT5YPcbEe957YPvaq01bSF/DxAepzEHLr
         L5Tvu6EePI9hrR/Thod0nK2tTLfUybTq4BbyUkJnJivDnWUKpn9VC17xFg75uzs4WZlh
         0Y2oR9yfC9SZRrLWxERcT/wX1BSLISkg0qgYkmWVe+gaUqRgZ7YQOc3iYHJWJTIFFAaF
         CdxyMlPdpiatHzjg2qCWAdQ4hx2KfZ/429jKKcAIQmEwY0aMCChoOoRbTqP5ssmmeVlF
         aBuNbDDYJcjfs0ICjcDfAqRyLRZtmz/GTImry15cpjQiNrHOM0qBtsqAxsrCoBePhizF
         PV1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794104383; x=1794709183;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=whgMGO08w0bti6oHmDssbLwFbA/tph+QoSDdsYvM5SQ=;
        b=bdyIObR7f6JLvqfs5fD7C6v4S1+5HKadOI6VoMzSNRvg+NLsf0cUGT2DgyhaFj5ZK+
         zOGtHapvZvAbVANp5yR7fJxK9cFFR5qDMlITBcCEVl5ml+0VKc2gPQ4OZR378OvzjorL
         9d27Yd3XM/avfNf2grfpciT31OjstTpnliIS1XDWecxRBn5GNzuCWRRR0NPDsfbdh6E5
         j2D39HLWfGLJN1+xY4JyAoL9OxiaLjv7XGd2dz2iJ4MytYdVcboezSpzK3N5lw0kIZQe
         6SbMjQyJJxBWVxY0kTJ3jWmRymkO9jqmjQpoVPFIf3aBXOCilVEupPrw4eHmQAW/u32r
         L+aQ==
X-Forwarded-Encrypted: i=1; AKwUvBz7ZIzTY8+BXGz3VzFAxxuhQM15NO62uJV8q62gm1NfZRMtVbnRzNgT8WGTlz1rcarbcOIRLVWzCwqU@vger.kernel.org
X-Gm-Message-State: APuU4Z87LsQuPO71kywlOIxIkXkbH/ArCobQxMHq1nDlOJ3EN0mHV/JX
	+Jijro3606shli0GhQB6pHS25IEwlloA8gwYW+w+l3fpnsgUCITWsmHxUwNBHFYxm67SWrBXe0q
	ehW67cVIK3xHCQXKGDDB7jdw+qbs0N+0Fd7CRayKxdQ0KEsqkn112fx8ABp+DHEhMN1g=
X-Gm-Gg: AYBFou2btwUAMTqMXcqHjZRD207GfUtO4ZyLuD0r0bIROHKlu1yqENZEMHcrBLDa1lW
	Pe5Jxm3NdpwMkyDNLl0Ou0QDsJcs6E3eRHJ0ocjhIW0AyT1xTi3tdkJwfxY8Z+L9QpkF1jbQQ8S
	cWNgnn/xOt1TIMxmB4b5OSIP2N+YZhSg1mut0kz3WoUTYC5m64TpVyyPXClMLHJSV27lTOGqJUj
	bDdaxRw8e86+Hcz2nzvZrx7KNPKJpfmtAqyCaD2yAVY4i+oYTQ2pE8xfPlO4IfOq78wifY53uof
	Tays1cme8GIU/DrBFoZ2tCyLDAbFpgQf76tT1kWr11wip9SViLrVyh+LlJi7ni5aMaz0PqoaHpW
	zOM4mjW82tJZDXB2DSQ8e/U3l6LoAVfDZiyB1VH5s3B4oR5ry4o5pz3VBMPNWDvMwLVtoK0tVUr
	+XK4qsnRfB1GYVp2j9cA==
X-Received: by 2002:a05:622a:14d2:b0:536:8f5a:64a with SMTP id d75a77b69052e-552a604e7b7mr4343601cf.63.1794104383130;
        Sat, 07 Nov 2026 18:19:43 -0800 (PST)
X-Received: by 2002:a05:622a:14d2:b0:536:8f5a:64a with SMTP id d75a77b69052e-552a604e7b7mr4343381cf.63.1794104382729;
        Sat, 07 Nov 2026 18:19:42 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55263e65c37sm7398731cf.11.2026.11.07.18.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 18:19:42 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v2 0/3] fstests: test that RWF_DONTCACHE I/O drops its
 folios
Date: Sat, 07 Nov 2026 21:19:38 -0500
Message-Id: <20261107-dontcache-test-v2-0-7655bf08d6d1@columbia.edu>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADrc72oC/3WNyw6CMBBFf4XM2pq2CAgr/8OwmJZBxig1fRAN4
 d8FXLs8ybnnzhDIMwVoshk8TRzYjSvoQwZ2wPFGgruVQUtdKqkK0bkxWrQDiUghCkOlrE+Iea8
 lrKOXp57fe/Da/jgkcycbt8pmDByi85/9cVKb9zc+KSFFiVgV57yucqwv1j3S0zAeqUvQLsvyB
 QUlS2jBAAAA
X-Change-ID: 20261015-dontcache-test-be6094aa3f20
To: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <djwong@kernel.org>,
        Jan Kara <jack@suse.cz>, Brian Foster <bfoster@redhat.com>,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794104381; l=1340;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=cUVzEdFJA8DVFpv8wyZ2e8aXWqSn/lSJpUmAg78NDT0=;
 b=i92OW7DNVG7bu7wfx+in3o/xG/FKWWFrwocolmMLSsQl6SxvzRiSyTnklpaLTIKEHiSeEAdMw
 6UUNVBKlMTSC+muh0WcJY5Srmohd2TjPR80l7akK08UlEHgYuoWVEUq
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA4MDAwOCBTYWx0ZWRfX2fXc+plpnlzt
 Pq3YES0oiq4ZORdikxoKvrOfFwfyGP2aty1/91Mi0lehljCTxg/YC7YmX8fDyF4mqMWAIg17e89
 E5EROz9J772taWmgIWjMYvbimDBfkjgYu/yoD/+maR+kdVkQdkLzHTJz/WpkDdB3LQ33a6OPfA8
 I/MosWdKLkC8mJBpvVl5fvN8eV8CXBK9tawijBPbVs43q019AnMhKPRJxIlAaIvyvvSq3xm+C9U
 V1jUdHwMm8v1lK1hm/Bmgi301oZpviBlzjqBdL5T88h8xMR8hyd6BIxcY7iPaijkRzopcuYZDpu
 MR8UN8lXXJK98ABbghrEZkCt0JWgySv9btW9fHJvDzYvD1c2OuVPCvEP7h5uHSScZ8jw+syJswq
 yGernRKDItVf+yYyrxgvvCjKGcEnXvP56pF7K2lBby9jifkHZf/xgo/BZSlwCia6z4Gj4tv/W1H
 Zj88VhBMI+BhcCgvgCA==
X-Authority-Analysis: v=2.4 cv=K/a3jCWI c=1 sm=1 tr=0 ts=6aefdc3f cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=VwQbUJbxAAAA:8 a=bC-a23v3AAAA:8 a=Ty6xO_GhrNNmo2U9QisA:9 a=QEXdDO2ut3YA:10
 a=1HOtulTD9v-eNWfpl4qZ:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-ORIG-GUID: p8qNyWGzZU7cRTGC7GR41VbTFxxl-0wN
X-Proofpoint-GUID: p8qNyWGzZU7cRTGC7GR41VbTFxxl-0wN
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA4MDAwOCBTYWx0ZWRfXypOb5JOy/baA
 Rm/TbO8uujr975uJb6/5T/YbAu3Isa7Z6zaaQnKG3dJtvOUzW0f0pQdR08NiMLONEygGec4tuZn
 IF/6AiLEHX5A+tGvwlHotLtq079vOVFHpUzbPqk6UgQtDlLiqTYY
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11959
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 lowpriorityscore=10 clxscore=1015 priorityscore=1501 spamscore=0
 impostorscore=10 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611080008

Add a test for RWF_DONTCACHE, as suggested by Christoph. [1]

generic/810 writes and reads a 1M file with and without RWF_DONTCACHE
and checks with mincore how much of it is still cached after each step.
On ext4 without the fix, the dontcache overwrite leaves the whole file
cached.

The first two patches make _require_xfs_io_command able to probe
"pwrite -U" and "pread -U".

[1] https://lore.kernel.org/linux-ext4/20261012-ext4-dontcache-complete-in-task-v1-1-6ac801557041@columbia.edu/

---
Changes in v2:
- generic/810: fold the writeback wait into report_cached() with an
  optional delay, and give the plain cases a short delay, per Brian
  Foster.
- Link to v1: https://patch.msgid.link/20261015-dontcache-test-v1-0-6aa7583973a9@columbia.edu

---
Tal Zussman (3):
      common/rc: probe pread options with a real read
      common/rc: pass -V 1 when probing pwrite and pread -U
      generic/810: check that RWF_DONTCACHE I/O drops its folios

 common/rc             | 14 ++++++++++
 tests/generic/810     | 77 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/810.out | 11 ++++++++
 3 files changed, 102 insertions(+)
---
base-commit: d07dca72d2455f4ba8c660ad4c008541ccccb707
change-id: 20261015-dontcache-test-be6094aa3f20

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>


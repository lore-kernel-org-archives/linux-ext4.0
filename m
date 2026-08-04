Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF18E3E51F7
	for <linux-ext4@vger.kernel.org>; Tue,  4 Aug 2026 08:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785831890; cv=none; b=bAYVnZlZrMAZ1lCiiEGmOCZL07V2eclAjJNDGAEmu17xDCpx2YD4k3NLQBDEf9yxsNJKQhiUVM84i8QMfDqK/0CYoWaR0Peq2kQ9qfJV1r2dGksGayfDAeas40gncLPL2WqDHM/kmsxIbIhGMfbmCzbdl30KvCJRXCdqMwEegyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785831890; c=relaxed/simple;
	bh=86puSCo8/7+RjJOvxx7elk3qwZVFGfFOatl9gKINYA8=;
	h=Content-Type:Message-ID:Date:MIME-Version:To:Cc:From:Subject; b=QkSghXM7oubYRND4OefvutOlPA7vwRZxC4837TuhcafuHl3PRVZHxWs5mtxrDlQviik5o3H6WZFUB0IX4Cda1Lsp2qSA1VgijwhTPmwcggOr1Tvpw+ThGDCzaShhShDabTKVuQgKPKPNO9JM4Yx5EPlk2CHZthhpflRJWJL0jLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WRr3xRPA; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WRr3xRPA"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-84a32ff53fcso399237b3a.0
        for <linux-ext4@vger.kernel.org>; Tue, 04 Aug 2026 01:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785831888; x=1786436688; darn=vger.kernel.org;
        h=subject:from:cc:to:content-language:user-agent:mime-version:date
         :message-id:content-type:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NBKQS5n8a0M/8zQTu/RjFioscajTM7HGhwLqpXqPla8=;
        b=WRr3xRPAWN6ewRNLYr88om8T0Y9AapXuSNGcYg1qM2nI1qbDKsU6PRehkyEsCiYtZx
         LwjDkYvdtEK2cGGdJfJCaH7BH+h37R4qsG+UxHH/uLvp8mtGofhrJ5W9XckVw37/gHst
         ZXzD27YUjie9FqtElncDzHV6Hb3ucwRDrR4Sy3SJe0hWQ9apN2HvcdXj2ZSorKvlWu13
         WOsBK83/AxjnKVT5Dm61mjeb/Ye3J8ylC7HSCieATvzzcyyfPTPIIdU6kkSfn2rMgIfe
         db9ID/d7k+jCHLganWB/wTR8Mgtpl4l/M+AS3aRe+S8GNo8FIMWyHMP2cVmvhTci/TBP
         Iedg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785831888; x=1786436688;
        h=subject:from:cc:to:content-language:user-agent:mime-version:date
         :message-id:content-type:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=NBKQS5n8a0M/8zQTu/RjFioscajTM7HGhwLqpXqPla8=;
        b=TCChioDZE86kO+Unpr5TvfeqQ/MNCjzCGOqXbpZbS9Agn6iwGfazAoplAJHWTp3KfA
         usNUswM2xXqN6itOitHJ4aBEoZpsIyGu9Khq8jATrqJdxuwnfm6IIZIV5t2XpVq8InCp
         lpzdlCMpWQ6a5f9ZoB611dp3Fd3SHm6WVKebHAzs+fSCBCSyLoV4rjYq8eoF7mTDQMjA
         M0InqHCrau8bxhwNHLgPq5h4/rQbf8wauRIUTpcxlvPkHZME9ZghqYmNsiJdxpGcO4hl
         Ca/IcKxEUqyYhIS+LuY8EQOPi7RDLUKjVXI88vBQGFww4mFravuHK/OuJQ1c2wwivhA4
         J7mA==
X-Gm-Message-State: AOJu0YzF2JVqOicAbR8vQsPIYakUarBJgpgPa8Yg6Lh8K9aGEzUM8ROf
	878nsG0pITiVTD9ZY9HEvgAW/FTfHkaWjqwLWIml2eBjsRwoGyAlqmEi
X-Gm-Gg: AR+sD127pk/GuhczdY4Odsn3//byRqufeMV7tgb0nGfiqFDscVY75aJn+FmjOEukopH
	CBm62rIAEIZxFdwVwy0Yc4+sp6+rmNbBjrwM/fgoCULxg0s5cyUWGfxPbBcFk0EJo+0h5NhrBQM
	J7ZjLdKldtRpwEjOo5AClyDHkqE8lOxdClWqfsm4CPw63HgoxSI5gUu/jo8/lpY+ANVj8GMAO5u
	IYyhU4zQHKvXe43NxYWlRnOMxVwNM56slLYv0sVTHWVBP2PmNVHCwj2XMO0AewEfaXbHs17KNam
	xMjKAjxYOYQ+MFprIou6BHWl5clTM5K/40olNn7FncJ3RJ4qU+DKVr1K4ZoMHDhfTOk0mZ/svfa
	bFcK/ybo9jSgaFihzh5F6UXeN0on6pLL0dnMwQlCFE/Asg4nfAAaP7TcBeTwTL4iFZVAGt3Ty/y
	RgZ7CRBp0U1U6splcRKaX7/ycoGqThr83UDOQjIdQ6Z6917fKmFu2uXOAge1lRr/0Lq4/ur5OzG
	Bg=
X-Received: by 2002:a17:90b:4b90:b0:381:28e0:6248 with SMTP id 98e67ed59e1d1-38fbc3f0737mr17939126a91.1.1785831887647;
        Tue, 04 Aug 2026 01:24:47 -0700 (PDT)
Received: from [10.70.111.138] ([202.189.104.49])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38febfd8ff8sm967901a91.4.2026.08.04.01.24.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 01:24:46 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------cm5urgjmId1dtJNaCMwu6yPy"
Message-ID: <7e4b109d-64c3-444f-a5dc-93c2ca4576cc@gmail.com>
Date: Tue, 4 Aug 2026 16:24:42 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
 Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
From: Junzhe Yu <junzheyu1@gmail.com>
Subject: [BUG] ext4/jbd2: KASAN UAF in jbd2_fc_release_bufs after loop shrink
 + fast commit fsync

This is a multi-part message in MIME format.
--------------cm5urgjmId1dtJNaCMwu6yPy
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello,

I am reporting a use-after-free in jbd2_fc_release_bufs() when ext4 fast
commit fails after the loop backing store is shrunk while journal I/O is
still in flight.

Summary
=======

On ext4 with fast commits mounted on loop0:

1. Write + fsync (fast commit path).
2. Shrink loop capacity (campaign case: 32768 -> 16726 sectors).
3. fsync again.

Journal block writes fail; ext4_fc_commit falls back and ext4_fc_cleanup
calls jbd2_fc_release_bufs(), which put_bh()s buffer heads whose pages
were already torn down by the loop shrink / I/O error path. KASAN reports
use-after-free at fs/jbd2/journal.c:942 (jbd2_fc_release_bufs).

This is distinct from CVE-2022-50328 (jbd2_fc_wait_bufs UAF on the wait
path, already on 6.6). Our crash is on the release/cleanup path after
failed FC commit.

Affected
========

- Confirmed on Linux 6.6.144 KASAN (QEMU guest)
- Files: fs/jbd2/journal.c, fs/ext4/fast_commit.c
- Needs CONFIG_EXT4_FS, fast_commit feature, loop device

Crash excerpt (campaign)
========================

BUG: KASAN: use-after-free in jbd2_fc_release_bufs+0x95/0x170
  ext4_fc_cleanup
  __jbd2_fc_end_commit
  ext4_fc_commit
  ext4_sync_file
  __x64_sys_fsync

(Preceding ext4_end_bio I/O errors and loop capacity change.)

Reproducer
==========

Attached: ext4-fc-jbd2-fc-release-bufs-uaf-repro.tar.gz

VM-only (KASAN runs inside QEMU, not on the host):

   tar xzf ext4-fc-jbd2-fc-release-bufs-uaf-repro.tar.gz
   cd attachments
   docker build -t ext4-fc-jbd2-fc-release-bufs-uaf -f Dockerfile .
   mkdir -p artifacts
   docker run --rm --privileged --device=/dev/kvm --network=host \
     -v "$PWD/artifacts:/artifacts" -e OUTPUT_DIR=/artifacts \
     -e RUN_TIMEOUT_SEC=900 -e REPRO_TRIES=5 \
     ext4-fc-jbd2-fc-release-bufs-uaf

First run builds Linux 6.6.144 KASAN + guest image (cached under 
artifacts/).
Expect >=1 hit in REPRO_TRIES attempts when successful.

Impact
======

Local DoS / memory corruption on error paths when loop (or similar) backing
disappears during fast commit. Practical exploitation beyond DoS not 
evaluated.

Happy to test patches. Let me know if you need a C reproducer or 
syzkaller prog.

Thanks,
Yu Junzhe
FuzzAnything <fuzzanything@gmail.com>

--------------cm5urgjmId1dtJNaCMwu6yPy
Content-Type: application/x-gzip;
 name="ext4-fc-jbd2-fc-release-bufs-uaf-repro.tar.gz"
Content-Disposition: attachment;
 filename="ext4-fc-jbd2-fc-release-bufs-uaf-repro.tar.gz"
Content-Transfer-Encoding: base64

H4sIAAAAAAAAA+w72XLbSJJ+RsT+QzatGJOyQBZukN3yhCzRbkVbx1JyH+H1QCBQENECATYA
SqJbjpinjdjXjf2F/bH5ks0sgARIkS33jO2J3jF8kKzKysrKyrtQ7c6jT/4wfCzLoE/FstT6
5/x5pBiqVvxhj5iiGLr+CIxPT9qjR9Msd1OAR7Ppz9P43Yhvgnuo/w/6tDuTNEmC7FOKwe/Y
f6bixjNFY4b5Zf8/x7PY/2uehsFMNm5l3ARTZpasdttRcvkR5qANNk19w/4rmsG0cv8VSzUt
3H9Tt6xHwD7C3A8+/+L7/4ObxmF82YNTno7dmMd5NAPX97kPT94oqtVm+Ed521OYYqtPoNk/
UA1D6bYgTyAfcYjCLIckgKs4uYlhlGR51v436QvWT4NVlmVw85yPJzkoHQPwtzS+4mqQgdLW
zbYKTdWWX/AhKbHSknZ3d+E4ge/2zvaOYRTmgA1LSNSPgUT7GEj0D0DyBgA0tW0yZujKW0Lx
Dz4VRtwF6y08f/2yV9DYgyxyh/I047Ib5DyVg5RzCGP4eeirTuA5KY+4m3FnOA2yp+y2a3TY
rWKxCqPGdPUt/JCGOaeNzMJ3HHRcLklBCkGgKGT8mOpbpmEyGM4gd7MrCLJZ7DkTNx91TMWQ
Kny6oWlvYf/0dQ8UOD086AH2w34yHvdqg5DJOSIK4xwlzWybbUXX4bFaoTEMHRf6rZv6N27K
IXbHvAf/3j96Da+H0zifgqq3mQ6n+3CN7A91nb34EZ7ihIc/7oCbeiPHcycZBOHtDijdrtna
geeHJ2e4YYrZ1mSfD0M3lstfKjC9w5SOyhS9IgGNvIErcaMIzlPX471al6VgF3xzvnf23bOq
2WZd5CX40/HEQXvtXTnRdYRct1Tkultjum0ZKBgwSZEBuEWTJM0RzAsQzKxvTlezCOGfwXEm
wa3jpO6Nk03C2IkSRB6mv2TuNceRCqNtrQbifmldMfBD5QC3WddxxJWbuXGNJEsgrsOZtvH7
MGOspC0weyOOlKdufFnQLaCHNWhNMU2E/mDsmt0leH6b6wTvIXg8nSAo5wjqBzVQ3TDtOjed
YXTlBNE0GzmTaHq5jo+GJrgyH3J/lnsjcBqGIxxnvgIe+46H4h8SPw2bwPU6fFdldfrnkIrm
+wirsm4N2DL17jpyFoNWqbF1VREDeJpm/JeC/Qiok6jVMXeZyQRgEEa83CUXKXf9azf2uHMz
dBAFSQTJMqY/taFdUlUiisQz5a7vTGMSUCKIoGvLVVmxAkG5sAY0HxGkmR3SgBqosob39SGr
i1VVZs/399Yk2MxJJjx2BWd0QTerg9u6+bvwa6ZKon8dZE5hyRZirOsrTFF1TdGEGMwpESPm
tsCvQRpM2BI/ITAPrY1j6gindZd3SDVMYQvQRacz5+yns/29V68Q1BF23xndBCnaSJqARIxX
phStGFn4weFpDxjTtB6CBK6t+74bMFer4CyURbR3iY+W1tTB7gJTQLfB1sCz0ROAp4FpgsqB
BaAEYOuIb/mvaNfn7YRkiKYVVAMUuwKzDfAYWNiow9AG3V3CwAz4RrefgeZTQ8BoZvxrWaAb
REI5iQAvqOMeoUd6LQ/dAjAPuL1YloY+E8VzcCaWrw57Is0LgsDtakPX1Wzov3i19/KMevFR
dRNOBocvncHej2XT4tHdCivKEwqPAAqWHt+FwfN7Q5HWwX7Zupb7mmpqRObB/aEqEn84H1rS
zV2c5uDwHmwNoWYz2vbnp/eBYMDsdRSybp1C7lp1y6zpXZMoVNjKknUDaVGUFYTEyIGiFq2G
YWl2oHLOvBpCNN6MEGrraFH0ta3G/dYKoaV2Sem+6RR+udbRtXCmvQitkksRxzyKUVEdKijb
qLlA8qyFEydl1Mgz12bqKsLTl6A8d/K0gFTJQWl1yMLKOE4BezV2iQqEtIPloEBnBukf5PnM
ifww85xLnrcnbpq3GdkYhQykVkOtK5qqLg0I48IL2MumQ1e6NnkBMbND4FmeTj0C5USuXdtl
FGvDKpESOsfn1xURKplE066Ba4WRJnCytQgzVMjxKppXh+qKcMQbpYhuDogGh7DVWaAbwsah
LfQLO1eC2r7w+0adUEO1yNpTNFmZecxOyBRrw9pm6SYTLhaxomWfzHEqwr/qdYaamP4vTHGJ
VCVQy6XpeQ3UwoUv2fff8DS6zQSpD5l43bYU+/eY+Gpk1+7iyBcY/G8QbgPDfPvDhNtQFE37
IOE2FFtRlpFS/oGCEyQEPkRwowauGpZe0wVKXcQA4WwFi2uiZaBJLCKpqzEfYziPQckc2iYW
K14duGtqS7pQBo6EmhNqsxaFGLrZnavaPMBcqIRK7KhtNUrUKjBC+T6BKUsEYzBXEBxMpoRJ
C4gBrlsHsVRzAeKUIYFurfDJ0lh3Sbi8KBGz2qvhuIGWTf0A0TJsJO7vEi2ja1NUdY7J/nB6
eSmqAynPMhjyKIkvs3klIBn+zL2cEsfVnFGCledmFHqj1fFif6E0j7JiLpJRxVzQgrGmvpaW
MIO5aacUNefYFGehTyntvekDoSWKKRMgpPwyTGJ4s0r1zso6LNaqmIJmksLYB5kyGc2yEHcF
rdRlLX9Exemi3ojGuRczrID5vqogQYGXYIrbU2DsToqvjL5OqFBzzyWGsc9vMaZjMAniHkkH
kVtNVUhcELmXGbpOskuLx2asSTp4F2PMt8vu3iUx31Wr+oVpYZxTkOnkswmn8XOn36yB2Sqp
NQb/CLCCv2IihZ7oE7DB10UvehrmeexetFPh7ZoUGRd4V5e9NAv+mzcocwI3hwkWs8nF0bJE
qk4mk3vuNMMFCsPUg6Hrg+t5tKM+z1GuuV9tvoV5Bq73iI+TdAZoRVGK3BT3yRd7viQQvdqo
LiPHuiRVyAkMplwIhhB44u+G77RirfheYdQFHSsYbdarQ5dxdfVduf+9wmhoZM+fLUv+Ko2b
MNZgKoymKdzO3/f8pcJjWUxbXasxX+uaNT28VrurqasYTfYARus31mozhQpGH7HcZysauZ6D
MHOHEWo/GbkrlEgSMfrpTzlZmiuexjwqymmignma7MO3h+eieDkK82xX6RjSP7uE/w897U46
janUESXJxMlGaRhfOZPEa2ejjzYHGYnfOP8zUESq8x9G538m2scv5z+f43n8VWeapZ1hGHd4
fI32ORtJj2HAJ2kChj0Muoqhw9/++j9A8oG6Y5n23/7zvxVyfpCh/U7SDJpRcslaO0UVGrC7
LPOvKzVKGPaCzKcJTMIJD9wwkqTBycn5bmOr6fmA//thSkVp/MoarQb86U8wufFbDenw6CUC
/YofPbmTjycdxDx1g3Y4vnzfkI6OCcWv+IG94zjvZLN3ovKEfa9OTk53Gw3prL9/fjI4c168
fvWKgOu/e7JY2/sK6uzbweHxd3W4oqUni9Uj5A+Dw/O+c/ScYObfezL17J2e9o8Pyq7Fj56s
Yt+Ls5+O953zwWH/jHprPxEzARTTOM9/OkeIrWZzeXrYBkNRWxgzFSOfHx5XaPBHT94ifnaq
IwFEKQ2nYeSXxbURjyY8bbbgV4zg3rwB+RZ5vRjfgLdviekpz6dpDBRkhgFQIdRFPyxfw6Xn
wbMOppudeBpFX5NrjkUoSB3yiQpysoyvsUpQ22uIAbUpglBa/Fak95IULAqGJaFIxFpaawSs
zKoszbL15/k0uPgIRRCeiG6M7inDbI5nsBWMdmBrb/Dy+zfs7Q6wFiQp+CGHra++FrAEk8Iu
lBlB09J3RFk3Tpo4ttUqoGhEo9AFkm+Mgniaxsnu1lcNWgVi+AYYgT4piMTVYmiKQc2oNMIY
nJeLptg7Eqq3W64Hk6mY4nGQMxxdFxVaMipHo+AV5TX5dAKyh82EoAHq2l1b3QQcOyRviKAg
y4hE5ApzHKtTfhjOx/AiST1KCWSqYqOV8a7IzQrUzSxBbS9cbdYSiy5J99eRDnd3xAReA6yI
E+tHfhZldhFzlpz0xzy7hDu4TDli/qUPT9ZZp7vy7K+5fO53t+YssLXpMPCJIKA4xygnn44p
2UD60DxtWgwJd4wgZKzmOrjEiaJj3eD3Up66EyjnhP6Ph+frNH4BXwJK4yu0tSBPSsKkdAxy
MOei5PsoC7titnccvUES7BZdMMx20QSByKCwrW5GGyJsn2a7MaY8OEGQtckIg/wCTQOqQ5aX
Zyo7fxnz3PXd3HW8bDouZ60ZFqkw21vNBRPkICQLJGej5KaEb0kFZ+VcHHwsuFQuSDpHZe6T
Y8Cf5BEUvbF+XQWgWJpytFjZ3Kgvr6oyTbAY+HuwLvzBMtr7RmC+HHTIL8NrXrhgP8WvKbgw
RrXBpWOYihlsNMM8f+J6YT6DpueOJ254ienWos0b0YlKcS56hVlZkKS88NctKYs46gRrq7jn
QkvkfQn7wSEJ32pm/BdQFrZVOKpG62vwE9LuNazYIN/kRCqtrBmLuWbmnEPNrzuivZ3f5gKK
eyN0KysxeGHg+W2Yz22NLzj5MMoN1GycpZwDZ8CRlQ0RR1t0DjkMk7u9YZLmZNZ+TtD6udHd
CvfvDjsn5AqS9Ml6qtaQQQXiEF1Ak8aS79yBuHyLojWnrSBnEzULKqrp70qztYGMxabhaitK
Vl/eaEiCJ8ofO/35l3/aS3HZp5mDkrzN7/9hAqiylfxPZ/qX9/8+y9PZhvMwnkERIiy9SfQN
2fVnIvkjPxV6GPeEaF6imTBCUTgEn2Po7PPYm6FPmSXonrHVg+2O9DiMvWjqc8TixXnUHj2r
NWW5HybLTdM4xFZqk9BFwdgN4yZ9cdNLb4cMaArb2/jjepENNKkLvtoFtVUPOlWKrGlk4GOk
LkJ7GvZGwYj+xBkc/DAQYTohQAiMxJdGa4s+4gNCtO6B6AQizg2o++sqb8GY/v0fzhq2yxd/
6c2kNPmYVZ/qeaD+w0ytrv8G6b+pql/0/3M8G+o/01hEQMeQhxgWfF3GP6QZbg6U6+SAkVYt
ImhSxLh/CB2MMblMr/VdyXtwiZlqq72m5vNhJR9R2VB6svG+UZRbmQhMw+XA9HgRjhbRSv2t
0q2ws3VM75WWaXFZi9hY82zUAlMx41azSZ/wFJRWYQaGmMJezTPbRXJysCHsnQfXWhGaFhQW
mOl/pK4hYerXEL8aIGOQrmD299nsiKj/fhq1XzwP6b+qGov7P4qmoP6rFjO/6P/neNbrf59O
s2GSoB/FkIAkmjQ3ClHlm+WhiKgvoFqIV4cvpxwtwlNhM8rz4e+P1ir+OoXHTIJ7gJJYuqA/
nBP9Az/tzqC/d3DUb4/9TzbHA/G/xgytpv+muP/15fzn8zyPhc5SjH+xrph5Aa/3XkBzcRKE
0XqW87QlSY8fwxmPAtlLYjof5T4I9YXmQeKhiSgtAwJubx8kmC/kgI5GnOMXQUNpRpIYZsk0
FTdc2tvb4s2Pha0RNiaDi+G7w7F7yS+AjiBc6UDcMSiNjh9mVzvCadMECPwLH0/lbIZkjuVb
23RM/UI4dbHQ5sVG13/REnZoSu+4bG8ncTSbmzIa/P3R9nZbki4uLoSJRDOGIYbrjagGl6Fv
F2subGJZjJQDTyaW0mfJUplYKk/dgOqsBZ9E7axdlWKp3hO4XoWTuCbLVJqVJ2l4jeCXnKqg
GGuEHi8qjlfX1B3z/CZJr3aJlfAfGHvI12hgT3846CyQ9qqvjQKEw8nr89PX587B4WC36p13
Dl4fO+eHR30Ecs76+7tdxhZd/dPBSXmOZYjGh1ZN3JOkF2GaFcLgJzdxlLi4w6/CeHqLXC8v
rKAc0E6X21/ISzOLkptWG15hSJkWW53yacali4rqzpKgXAyT5Ao5MqYjwos2SeLZVLx70sMJ
Lt48fVus4eD1fv+gvPazqah/QUdBF+WR//EFgSXTfDLN29KrhF4AuqiIEHpQlNMcqs1RTe1i
pw5xPXYyzLrciC5YEmWPUZv26T0tf64XHQhpJdCMwiu6DYb8KS9msi4q1WFAagNuROcpmL27
1xzccgnL6pLN3l25UcRTOctnKGtCa3qVJPNbupEC3/UHx/1XzuHR3sv+bkdcP8qTOT/nQN8f
3QOosbgG9V3/p3UwvpNmrlS8ckBqukg6C8lAJrwk6mShfJmXhhPUA+kOXpCS3MEgoQ/pThbP
/AP7f0Opcdj6Q+un5XG1GF+vgdGQoqGpti5gfnZCYCupMhwT7N/+63+VWiKEkoFZUxqiFVmQ
trRWGiOCpqdwdvYt/l9ghSbpbasctIDtCAzlsOfCvhQS0inkA3OamHOf+6UNFJgFjvJeL407
TUMU33IeFDkiTRI5GuzBBD/ofTm4aIsQDLcQgwESWPzdP9o7fCUEuP0lKvv/+LQ74m1lehGZ
0z5/ijl+O/5TGAYWIv7Df6ppqFT/0fUv9Z/P8vR/PEefncFNcV8ZmkVcIc4aWasH9TOlnmZo
PVgcI4HC4CYNxZFXnqDhSzBWUjQqFhfnYOI9AuhamtWSnk+DAM1oNRgDv/pUO2SXxBu91Sjp
I7zxV7/Re/8yLwZ4eTqlGM5x82QcesUtuxtxabesTXeE8+1UoNxvj3pdE96EMUWpbx+Yo0Ts
Y4q7jLHoKD/kFfxGV/3QCeiF9+FoBflQ8NsZ4XIQm8bsD8X2wP1Q9JodAumUh5xtr9fVVemB
a84YtKi2zWrXnDEsaRtt1bA6ump2JUnca2bFvWZqKS82L8A23Wv+Z1xkrt9cnl9VBsepbifT
KUin+ok8smv833iN+f4whZlSeZm5fO8Z5agIjOjd+vG4I86v527b62mmXptowzXoNeN005Y2
XVFeA27Yyv+x96TNbRvJfhZ+xTxECUmbAA9REg2H3tVBO1qdRcrZ540TLgiAEta8CgB1RNb+
9tfHDC5CluxynFcpIofAwUzP1dPT3TPdrckDdL7mP+A6k6wX3hTYDQf7sL2RatInjZULi7e3
ta+0Tr/GUvzs1faFC+oTdtdYAr/WUtdpcKCaLza0x8yjC2rb3nyhfdJK+sH6tjdUQWKfJcgk
O6ZyxtRwPGygvFxwG1pWZBTcYKNgLKCyttuprKkPIDOlV95sOUMjnQFW8SyxKk5na9Yz2dCw
qShbo53J9oCRcraElrYyghJEnWo37a0aWRXVcMhnU1ql2b4UWSY9WHgbSMmTrZSyRs1DZ/jC
bsPjamzF/BSbZUQcNir28FZ/iwyJR231si1f3C354kAel16a6gUyO2jp3GLz43beirmRsmLe
wJ/QKADmbAunIYbqE/67Ldx22vZay5stQxfbLXe73vg8s+VH7JR56NzG5sjO2CmnBrTIMLme
GCZnUwsMk1tabInMcIfNkTPafMwSOf1oZHq8nPfTpsc5CBvZHm/VN9qJrXF2HJStMRpdu83W
aGgDhMS4+HONvzLWXlsvNkcvWtvNxNqr/kXWXsivaLFxVyObu5y262pUtAJDru1Rebhw3duK
xmZWOQiJtRYwRbZTb6cSNrba9XZ7eYwfs9eipxEnqHYsA/psA60nWmRluL3tEZk3OZ/1bx5E
+wtAvMrynNSK0Wf9u2TY+GSrqhy/2/6SujMgGl/S/K8gNuXvMubFNaNtavhiSQdHLNMB10+m
n7PRCE/+2pvNxnazDaKdN72ILkFeBJZc+8fufjMtRV6j2moxd+1MfeFi7gUsCuKRf1ypkle5
bFpabShpFdb4gEqG1hYSNhZMv4NKGd4GkB/cFRPhwhJj/sQEApYFyrPjsXeBREaVEmXVj8r/
l2ZoP2YflJDGgtl08Sr7aFr/3b9e7xwcWcosAaAHnnMlgrmjjdzOhri2p1GnRYmdupjCf2Uy
XRCwaewCYaDDCiWAzILPrf/P1nWsnuVHqXz/SF0b7XKtz9H/bdS3V+e/3+RZ6f9W+r+V/m+l
/1vp/1b6v5X+b6X/W+n/Vvo/lXel/1vp/1b6v5X+b6X/W+n/Vvq/v+YjrW6M8eyiZXg3jhfM
IxMSvkbcF/XQLvcJ++9WS9l/1FvNDfL/1ahvrPR/3+L5TvRZiBDhBy9yLsUomE2E8iCCSrmW
KPtup7VVISsRNOSwxcSf+hP/d2X0oQVNaWttR+ssEaLjJtM0q6KU8cbFTlhKVQHfKuxJhQqU
g2ZF+07szabOIgjQrwkakvqzwGLSTy6D2AXvxJuM3JdipDwhlaU3oSo64ay8BCjoNGXQ754P
+uc752/7W62yVDFipS/ZjUrim2M2Htvz0CO/Zcmu5C4C3I5e7/3F7z2bNSfwYBQNuk6OPo6C
afiV7UFxjT9s/4kO3xuJ/VcD4z9tbm+u1v83eYrtP4txQvsOPrENgp2yKwEmZg7M2xB4A2mZ
9fOxtF7xpwKg+sFsSnZSyOsFXlK0FAJAjG8UzWbjMIOJaF7h2FNlN2YYIpx7jj9CuS+xzLJR
gR2Q7jeE9ewBuLJnXpgimM2iMQoxNcHNNwJP8lRsd1WpysagHCNtboDRHPpuKCYfgFVDB8ff
KZ4XWTe0N7qwA5fAzkZEQYb+2I98LzTF+SUyv8TuoR9RqD5Ep1xVssFBigPAyFcVUhW02AjF
3s4ZqmIGO/vHByfiuXTvRBWCqIvw7HE4A1bwlqjuELp7BeyVDQNt0lScX/ohUMmZu+ASnujv
HHcTEzJhh8Uja0FhfH5kG6ZXaL2TFmTIlxYOIVnX8VwuFSFjnrhICPOF9mkoIX7wbkWZjIcx
GX9BXyJobKUYiDlfDBMgi+HYdxAG9fGn2bXwsR2oYA15d/pEnwxqNjDmwhKTCUwEzQKgzwQl
duqSKE899KCFiCTnukIKZvRMB/Oamj0Jci7d1QHIxKGZmx4w6O18MbYjOQ2M/NRWG5oevCR/
KTi9hAIVmjtpiqWQL4GAJn0kSmFrr3wbcSKazKFT5b3Tk9cHbwb73Z/Pj89e9wfHp29Pzju3
lSpADFk5Yg9Db+rwWQx5bWF4jME+W2DKMQLsubSDCSI0I9TbkBQq2GsTCinTzuCBPWJJAMb1
MrIX4yi0hLL6qor/Nt/sEsxe96i70+92osC/8b0nVUHl2EKxM7lFNO13u4edVv3F5tPKSwv0
G01Ttevrd/LVMlQj73VNVgJf+Q39aHI29OfZ2/uJXHnCX8uwJ+4W+hU9Puj1TnvkdpTeLOMy
iuZWDQZ8aPL5kTkLLmr8Sq5Fu9KhaPfQMpr11va9TsPGCENnZzBFx7vIYC1CcrFRntjAlsHc
5fAdTXDFGdtuCeilKfwRSNFITZ/DzDqGe+nMDWfsIzM1JGbGiy7rIGkTTtWA2atJi9EanqoF
QDI8pMdldK8Xk2ig5aG4gEGUeQEOsFALsjqFNUXCuSSS5AmDTW0DROyJj5xUbjeBlpdC5h9R
ygfAZVz1/rQa2wezFS6Il6bYcV1YMkClsck7+/uDs529w503XVM7O3zT7+jIckJxA6YblnRV
jUA11/8qtreK7a0Cezmuwo5fvXCcKjor2kJL2iq6OamGZAVVxfVQnYcTAFJ1bANEooj2HVib
VXdCvdTRDZx02HiXapdlwISmXZJyM9fxT3U9lVFH52oa2tzq64xv7H4xQBclkKzzHyTMetpP
I37CiW+YciNOLedrP7oEwsokzczQPFgPsBvAtMCYO5eUVL5GVR4XZrJMxAFoAi+eihguoqpY
TMkANbOlSfpJsxpmtsiXQKsZGDAUrkHUjkkiGSUTJZKcNesPsQuIQujviReysvvkjdOzrwgp
4YkJa0mSSHTwcmvyR8O4sgMf1Rf+BJUP9lThX2Y7LoWKQlm4qwDFHRNRtPEqACSw2TiDLPMP
2BwkZZUsDbTMiRbEhSBc3I6rYj5ehCywgExhJG2QxpVIX8VZ4OEVCKjLu5nDHgf1SX4JNjsa
E6oIKsCFFgoY5Slrx+IBhO04AnELiP2lP8cZBRJPKhk6q8aTH//KMxS4Mp/9oO6Oj8QrpnbY
fdc7OCFPyvLVMogDDGEr8GqyaFgrBmlezNHZsiw52OkBdpcrcjEg6sov2UWQzW4oYJ0ke4WW
Q2rDfq/xrCYorFKW51l9wbaie02g0XqcKM9p5RpM0pFpnWFYzrCDuFfFjSTwh9XpbEpXIeIX
Y+QHE7ph8F46Gb5L9+eXv/96r8ef5I6hJ4uYdwZas01T7IG0MQPB2cbj+xC5Wh/j8dBhBvLK
wOQ45NKzkMUhJLLDENCDuVAcGHSy4grDB0H7N/xdE3cirFk3Vs2yauK+xE0hcj/Hsi66E+2T
9TnIvtMQbarx6s3UZOdEpfO61dywAmSor6dWLUTRADYAEJWNI4zV0q+LBkhr9bq4ihr1ekm8
epWqA5cRrAmsZP+nvTPEPdx2zBwRS28/ukb3FEai9H5qA+GnAu+nyMN6vGcBXQDcB3r+fpqr
bnkHw5pHsCyGFnOwz8WMLktAd8m/fy2E3QVXaQ16P/IvmCWjBfo29Iiy1ELXBi5xxgSrhmAq
8moJURKitAS9o7Jj8ekM9aqWUo9QhSNZiWTykJcf4wURZuRe92v97t7b3sH5u9f9l4qAx6Cq
kh65pLDlSCxjAzhQ2L9wS0YK6QazOZIwHLaJB8noiw9XjSijdTmTarqRFcLqv0t8qZbintaY
31esm6iLeimVj0YNtpcaNKYmbc8pTagvqmSVm50HoAY8B0Mli9T3RyDxYObgyBGOvz0CA9B5
NIkGuLsLjH3tEKxRWEt/SL8XwrvPoiEhHGLeMd9tolmDzQY3uAhoUNI69le8wM0G1Wm450T+
eCxnmFh+RfIBnEQbRJlQ4sxAoc7gdR/dFELFEl2EO4PtGNHWmeGs82YONVUQO3dYloTmgSSM
jQBEkkhthFN7Hl7SYhkipXMmLt3m+Xdw/e/YxwSvE4BEy6r3z5cpQCBtRN6UvMSFokGICcK7
6hr5/s5iZyE9kOMm/+raGOT+cCQSt2oPZcU/Bo+VwSNtUss+EwT+NJJOmchVAmuT0Kc4bvP7
iNYi7slEklJgKVSzLmkpKSaINxVtk/7JZgYqOxtfmdhmVSRRjiyBRWi0k2C8vWueByLdguYb
+egy7K3G0IYt4SV/v7RD4jiQVxJzuXmAkAglKoriY4hqP+pB9iOCduuFOTILoPE/vFCEo0uN
QPKCsv1zAUT7Ehif3z13AAkhMXTz/D4lW0pCMfTRmNhT2NUCM/Y6Tuwu6QP0zC/UDugacvkA
HDBoObcRCVRFGCeiVMrjFW2JJrZf15z5MuClbLnOUFdRfADxBHZK7BpyY1f+pDkRETkgYofc
sZy2mAML49mTSiGOk+SEoELTVVO+c37eu8PJve90dIKsV0X/3fHRwcnhc5WSm5E0nNpm3cDf
hiRVJqVTy8+kxA8YPLGDW3FysCfkDqvYWnLEBpQiJFY2p+QCWgR5giw5ImliHniu73AZAEH8
pjed18MWhU3AQ0tY6/EXqBDkOVZZ+aGEF8I3KB7OFgFrLKIARj8e5HhT5zYCt4SpD0uudLuJ
LotcEwnC3GlBNqZrwxnUwr5rkUHxo0+So5hNAREwsyZzGWqNukG8DtTxQRc//ljCCSxpvxwj
ZvyqnQY+rAB7fAKd6fBQ0URo2i9HUOJXjT9gChbE6dswScTn/Z0EB9ioWQ6B5gKvCEIIq8Qu
VQpe1ICRyiicpIsYs9hLvZIzpZv60PM+kFf/7qEufdY3cp783QIhlTQtz28IpaWbyz1iX11L
4rkuxHoZHXvWklKFH3hZf+Ibk4RUTcksX03kXovSz/yWR25yazqji4pqSAlY9auJbom7UpwA
SdRXSBWNaiadsR4+6D+ih6BXyiuSns1G04LF9ZKe72cpl5fVoggyl5e7ns/uzBcIWIhmNn3i
TWR6vdVOvtyX0mNzcnretUjfyIgjdQGKtSRsZeIWoZ9GphcpOmEmM4EPe54KFC2IeY5wMadT
/2W4YRWvCCG4eHJSM8GPLpcmDgksJ9Mf0dbZqQMrNgsBX/Fnp66X/tqncd/+MWvmhR/5F9NZ
8IcdbT12/t9sbOXO/zY2N1b+37/Jkzil056RE7dnyk3bsxSx1ZQjOHZE96ymXlAUNW9+1zIe
7bQiD3gyESjfQHrOw0Ry1sjezua+u1rc3/wxa6SEldLTn+L/nZy9xuu/WSf/X6vz/2/zFJ//
53CCVBXs4pA9dSoDLEkWiGMn7hBNRAw2EeGrQUU+oDXpbPLnbq9/cHrCuuh0imXICuJzuQEf
ldwlvywj8ftJKmkC8I/T3X4KHv60jPXyFBU9FTyB6+0N0qcu+INteIx8IyD37tuDo/0n5zdo
1KjFg91/saPMTDnFN2JYqt0djEH4ACRJVXXtbQ8y4aFiaNVqjjs15ZTgqSKQZWl9JBVhV3k4
339vPrs3b2rrd7JCjASYEnSSpkG6jK834nTVAXLGj+EFT3t73YEET8NiGfV7HcNv6I1UGL41
ZhXJt6q3COnU8cYP6dYDN9MSGfhQIg6tJNvwPyxgyKkqBr4vXcci3HUYJYCDJ3vQ/iP0luuh
ILjBkQhTE7AuxwEFFy6UQOze4OkfNRRvgsXVa2tIH4y97HgJ42b0AGzqSQJ3jxhePvPiJfSc
l4q88FFez05aJXUQGONf5gwwnWp/8Lht8WiddtI5EhW0FuepyRM2qTnVKbIaRfCKy9VM9e29
tmYY3pTEfG5+9ufgTfek2wNpIZd8cAIybDdTHO9Mo9IynzA4O+0f/O9gZ+8ok3336BAvOgzw
Nh9/AEpihFEg+u/6593jwXnvLfzdR2ezfaHrYilDr/vz6d7OOQyqyvOEAZuN3WTMUvNIx61k
1SxpXtn4z3qKzFSeAtz4j54uoytgGuqmjMyU12I7LlQKx7QjtzxTDfxnMIu83OKCwcDTvPya
VmEQJw1R+o0p+pUXhP5sWopDV/zZG9Pq+SZPgTPmr17HI/zf1nazleL/8P73ZmOrvuL/vsVT
zP/tosKeyT1fUvOlZ2lUq+I9nbwn7DI61yen7GnH+Z8TA6TQEXnCydFv628ILJ1yry/5Jocy
6p3zq1+ZvOihnHPCW5wP3jO5zk575zIbvlpGAzC5ncly3D0+7b2ToZ7Tvy2jVX+xlcm7d/a2
L7PhK8eDlp/znvbxmlo2yTJe1OupAin/+3SnLf7JAZO0o9M3im2Wr8AKZzhoqXpkT+H39xku
QxbBS2u9g50j2Ibx0ohMzXqwhzz9nwandHtOZSiS9nVt/7jbfzN4A21dyprVFuja2cH+64Oj
bipfVlcAHaRaz87xTokPLeb507n5csZ05AH7sAs60U+zMDr0bvfQ9QDePpnO8Ntb6MbhFLhJ
/Byio/lOclgI3w/ofgbe8T0FxO7ceiGmAlM39Zzo3J940L3OZkXr750VtuXsD21LRYMtfjYn
+k2xhtdSbLwcwTQDvcYBpVHVsrYG/6cQXHaUygwrcW2NAlLhGIvOf8Vvv9SNF78+X5cxie/E
B5/OUel7QdCrl+La9qNPZriHOtSxn6pYWwO++V7TsPAA5EnEHe4StzmSY80RwRptlD7oXoOA
EdPW6BW74+IN5Offh9iR60vka7lOdwaV4hEp3r+UiMOXd/Ds7+/x0S5lzzQ7HQx9bQ1qy1eD
g14uYzuEIdv0qqMaLCqVePTXyDzOmIpWHZnEeGHp4tUPzZjzgnxxJPQ1HBVoN0URa2prFEQM
RukDLEA7uAjx9hXOdyDiQCA8TUkGyU8bFCTEmS/oJhkgDsrsIyTsMUsquUNC2PQ7YjIPoEKt
EUWohgbfyZhrEz8kYQ+/QF9kwLgGTjU12bnEy6Jb9XpqbRQFTONI1qUYqUsczTr+rVniVWbk
Miw6TGQiZvHGVUZa2VFLMMaiJeJ6jzO5HDoGBQ9AGDWajDDGhHsRk3pICieS6iBhZ7FJnpDk
hxc/oSUC7KR65g6RCK7VjawO37Py7GB8yzGbO0xuBYiMYWduT31H0P87RgMQD69UhHxJ96Gj
EzbwNslU3R6PMTqGPZlDVQ1uEh1jCx0lwU6MAFVAkokddQL7Wk9dE8H8UBWeiut4W7QKlAR+
16uIWp0GrqOm2eCfo2u3Ezlzy4p30XvDajZlpXx39MoPIn+GII2541cZNEGExTK7AJS4hP4a
QFCkoBqTNgCSxQfAqh8a4ocsHRFALvAC+PHpebcjYx5jQBpjPnO0p9AEPd4Y1xmKniyfB2OP
LDFJ6SgjvJ5CupJwpzYPrpuWl55tgSXrrekyxDWdtnqaIjL6eg6fdVHYL9yB6D7Kzhim+wBP
z6/sMUxZvseI94BV0PKhDDxeSMkhm+C1/fxGjU3tGXSWP104MG2nTaxWfUwFmF1OwnHBcioO
uazAVVmRsnEc8t2Dk04ByKVwpiLDGd0zQCIZgwFzI/3znd75YPCSK9WJvjA7w8iECDIInM76
3yQrq2l3SnGEn5DSDRy8p7rOOUllxHS+TXReQlOFOp2OkKuZxPAOBtNei6N4o3uuj0TCPha5
DvqYcwz0cJTxj6dAKz4SlShht9eyCyXTzdTUilTjFVm+l8HU9fWEg2OdYRILvbCx0s1YOetn
7GM4todGNq1iPiuEIAOxl5gSx03O9yXVrnR3CtSSTw35lFFNJj0VJYoC9UsDmKLSA4P46VrT
GCpt5T2Xoo2+AmKcUYhKAMavSfj10L+Y2sAdeGQ4QYjJfytfFJE9ibr4R0mYj5//bDQS+X9r
E89/Npqtlf/Hb/I8FP/TNaKZgTwKoYclrSbZCgH142y6kQnl91zpCkg9iplIZQAL2JQGb+wv
Rmbnq8lSZ0CXTlJ1vGQ9QgFDhhdOCg+V+nu9gzN1UPRIYGH6mhQAUvbEY6ZHjMgeO12ZirxG
Aw2GoFnSeCLNJxYde7wlJjujIsmW0rxx9iAnf/b0uec5OXVM0WlWwZmPk45lZ4kH2ojcyeHB
WUEzOsXHSmkwfOlI3oJfAoNcLcghkpg2oMrQSzc01uZnMJgOftLztpZBi/T5Dy6UDA7lz9H1
J40dEvmD4zfZrzFu3fMlOdZVPZBBXpbTskNKdRaMqEI1qDONd+8+fYSXWtcwmVj24QHNBOeU
MQyVXQwKy2VgRGj5ZcZ5LWUb1/GaoxBdkITVReSPDTrkrM69YExczFqyBmNzm9h4M06hnMuT
VGwlCg1gC6S0mIqjUqiVLNA48pDklIsE4K+hS5TZkilTKYU6xiTbfUY+P+RVtkwP4hx8soY5
YhUEB4densmlYwt9dWT1BY9ZS+LQ/lF1PHL/r7m5UU/Ff67z/b/NFf/3LZ7XvdNjsSDrUIsc
Jmta9+Rnsd/dPfi/9q5mp0EgCN/3KTY9amCjRxMPpvWkUqMmxhjT0IJKJEBYII1P78zAwi5I
Uo0HD/NdmplZ2E1Ld4bZ+bkINiANHi6D1XmWZxRqjxESTSyoMIOuvLY9cp6nuPOjxXbWGYbm
kPx42qU5Dets9062IdqFjgKuswiTDeK2QbB2GzC39YfIapwajL6AHU6GReVhZhyVk4tRwRkO
FnjAKkceRsdnudfRXhljtBIYurpL4qTk5Z1NJBqms2jS87HW6IwPU0sySha3JUWS22Rd2tdh
AevGGd9rQIv3msZ7i0yTLbbfRh+cw9Q6HTEnabUIkznfFQgYBCOTeyxBjWyvqqQCuAM9aGyL
uf90roOfpQvW0ffX6Bsil9xMxjGwrTuZWKhvKyyoAp5Ehem8Kpq53Qx7cwq7kH+CjlFrQlhn
VHy8YXLtYSvEkwI61vjR8BLGN2GpsPo3PK7wqSutjoR4XN9dgaqTCrNLxHJ9+zQJzJspzNF7
vyZa0nyXv/NaSl/R/6x3+f3Veg5ejqD5+9es4eWs3bfmm5lLOYo6NDGMrdAYaGSUdby55ufS
7X0uxPJmJZ8Xgytl8cK2CIPBYDAYDAaDwWAw/hW+AOE9gcEAyAAA

--------------cm5urgjmId1dtJNaCMwu6yPy--

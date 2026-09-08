Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FB936197A
	for <linux-ext4@vger.kernel.org>; Tue,  8 Sep 2026 04:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788840678; cv=pass; b=ILaFPuHPDztXWQmA+Zqnh+YOJSL8nl83bkgafBMjv3q1p/8llOH8dd9f8MAOEx9xUAWQQggxW7KqNU4hjihrWeLpNdF9M3SWIDhkkko9qsM8dVaVZ4j8bx1fgc4IQw7L32ckqH6y2nfD3jZsQ6VNwkBwjJkWcTw4lqZFuvtasek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788840678; c=relaxed/simple;
	bh=jSczsniPhvvQCy37MO6Dre5VLhSUR1qB0JIGD3RBcOE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BDaVUDLK06iwH/eWFt3Yh2hLtSjgZMzRj5zM2SRCH8i2ECQpLbt5vhZvcf5uslWWhRQ8l0RSB2iTC5ztDFojL8sdufmA284yfP9ylZ+cAQZ7hBTV7wPI1//qThDWcd88kknyT3OJAH/KHvNoHagr2B2rAmJC0nnTqLZGtw19Iog=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu; spf=pass smtp.mailfrom=berkeley.edu; dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b=QCpDVaLL; arc=pass smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b="QCpDVaLL"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2d8fd3b729dso33034835ad.1
        for <linux-ext4@vger.kernel.org>; Mon, 07 Sep 2026 21:11:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788840675; cv=none;
        d=google.com; s=arc-20260327;
        b=XZlvvlME8pGPWT7yNSd3QR5BkaHDWzyLst5rLAbV8M1cjDGM02CnYcfAqh2O7etMnu
         prKvFTSop+6wwM7ByOUsgrpAKpO0Zk0LKv88V/HDykEV1o/MQqt8Z/QJSnaf6mLVP6vx
         l6K36UHRbOwvnXG/v6DU63K1e+GCLLvilx13YWehkwe5mm77vFkENUYwfykVuHUf8Zvy
         tUrdsBkTnd7h5n5ZtN7jswWWASfxkqhGrTOvrRI7XHyeYwYUC0wC99u2UnFGsYIxLE6J
         OOGt3ngxjrlEapvurY7tDpzq8p9XMQr3PlWJr6IpxG+zmfR62gpEdgMBRz2om+zMuJsg
         Kolg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=NACF1mHDsALhIevCYN4DBwvAKGHyBbmDprBubQkPOns=;
        fh=Ukw9vyhvYTbqVr7X3DbIecit0wjVPS83y83woV5Vcww=;
        b=lfEak3gnTQag+dmfdGiFUsqTgyYR9FweRSWTOuFEEpLRgugXsYp0xdd/PIzN0lyl7W
         3UD15unq5CvSgXq6ldYMaSaOhkdTO3+dCSE9XihqwOwT22xJteaSEbatK8px02wzvT/9
         54AuZcl5Il33wvE5gqyozJ1MoptInMLI/iastTx030A2u+VrBMzOATTVQmBH0NACKsWy
         qNohEhPrT/Lk9o4WLKfgSs2USrl3JrEZHFaWdT3WNlIli++H2ba3SbvlgQ49adEMdmzg
         0hWuBw79hguN3O2m0cCat9RIVLFpuSUOzk7XITClCSIVLNQ17o23jgoI8GkuPsUHxJS6
         NRig==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1788840675; x=1789445475; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NACF1mHDsALhIevCYN4DBwvAKGHyBbmDprBubQkPOns=;
        b=QCpDVaLLdDovkNacqCQznPv7E1JeEyKyTzZe3ht1RYyTt5GZf1iWrjvTnmmz/q7SU0
         SR2Bwr3cX2H7t62lYn6KSdeD22pZuke9rZFiXJMXIPIePQqUXOcwCH0M12jAdZi3qsNg
         XyQtVLTQ6ByFusnwkXHig/705BQWB9ZZF3koEmTLT55HzJ51H6I9p3QYL/rKX8C+3si7
         EL6EMLLb6ttm4EzGw1hN0tvlItIFyA0DGvIbjz9wZunfyGlG4JHUTFZfQUYqXmi/6RgS
         eL1CQslXbudJkKoSAVQGv4YrxmoE8/G9SoBW9TXXRdNTKj+UYYkvhz3W7zt2abAkttWv
         JS/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788840675; x=1789445475;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=NACF1mHDsALhIevCYN4DBwvAKGHyBbmDprBubQkPOns=;
        b=stXl1WA0LVoukcqfZt979rr6tSgQYe0XjfkQ0IN1T9bBFxKwMiJ9s+XzBt59OCvtkD
         TcRJdMkHMW/lw+PfMdDhjrDTtzrJqVsftWxscGRQ8dyFKy/8R6fQ9iqpNA9JC6upuvPB
         qQeEnwr9sUXXClfhtBrKWXZqityFb7NFxSCReQfcMM8SZv5R/QEALTWgxML9E8/bdRqE
         DTSyt9v5XCdqH+6QqTx2pjWxjzoeFCs5xsLW7nULXpI/kWPSP5wQeGNnJmaRThHgaYit
         ZA4vHEGpqi8QDy7aVZ21+EM5T4XJbZR4BWbKbkE9qzkrVO7man7wuLx+/6tT6Osq2O04
         Y0ZQ==
X-Forwarded-Encrypted: i=1; AKwUvBy2UDSEu6ZWgr4SHTwS6iFrn1j36sh/Qp39TVZ+7q+wQi6CQXmwG38bLP1kGEAJOG79Q683jmxh7M5a@vger.kernel.org
X-Gm-Message-State: AFuF++m3u2PQ4Sl7pe9pOrkLGZ4kxCmRYCmKJDJdvZdVEK3P1VtsMiiN
	azdbrTjxWvaBQXF35sekRW2+5nge9PEu9EVD8xYyRP+1QAZHo+PNN94NW4nos3gpwIfJO+OTnEs
	ueoj5s20GrVwGjtxkNAnmxRKphUlKixCjgAhVZ85I
X-Gm-Gg: AYBFou0CfkcbjTob2JHfriFp/fOvOj0HG33HWgB/9rBH1wJeSIs1SUmRV5UzNT+Q6RD
	ZGlwuOHrWD0iyweuRr9A1qoz9YdIZNkYQdF8zMKku7qNMgFni329xNSOr+K1MWq2BCDWzT/RYjh
	wXSIoou2TzI8MKITY6ADcF7pNNze67gkgbu9H4mHGJ4YWEuiyMMolrJ6VvhtYNEfxludXEbzoT4
	gZahG5CtBTi8m4bizYFnC5gdVoHDqBS2+CCKfAkHstf2TO2HNoURx0FZrfffIACBDCZgvzn+Hk6
	3JoFPk1HeD99pZy2BiCedgAscpNzxAvgznMdb597WhAbO6qhXDBANF/bpxm9m/BZv6DMpLA8lhR
	rOtV5Bd6Eo8uP8ATzJ5Du39HgR8g2xgo=
X-Received: by 2002:a17:90b:56cf:b0:398:dcf6:d40e with SMTP id
 98e67ed59e1d1-39b262aa580mr41210459a91.17.1788840674554; Mon, 07 Sep 2026
 21:11:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+0ovCiKb8axo+R-RsqzGbUsrVE0AcLbHqy=+-c9oSMCAqL1fA@mail.gmail.com>
 <apGbKdJiMx8nCfEl@mit.edu>
In-Reply-To: <apGbKdJiMx8nCfEl@mit.edu>
From: Farhad Alemi <farhad.alemi@berkeley.edu>
Date: Mon, 7 Sep 2026 21:11:02 -0700
X-Gm-Features: AcwNN1UYBCSH5A2hJgM3PpIqoboOHM6LnyVHWwC7eYjFsBSpLnGI_b-UeW3bNKo
Message-ID: <CA+0ovCgxFN3TLpdS_O_Z48sARuQ-WR-JLDCqQWEmd9ELtkzddA@mail.gmail.com>
Subject: Re: [BUG] WARNING in ext4_journalled_invalidate_folio
To: Theodore Tso <tytso@mit.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000f86613065af0ec65"

--000000000000f86613065af0ec65
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Attaching the reproducer; thanks!

On Fri, Aug 28, 2026 at 7:31=E2=80=AFAM Theodore Tso <tytso@mit.edu> wrote:
>
> On Thu, Aug 27, 2026 at 10:45:30PM -0500, Farhad Alemi wrote:
> > Hello,
> >
> > As part of the kernel research at ASU's SEFCOM
> > lab, we hit the crash below. Crash reports can be found here:
> >
> >   https://github.com/farhad-alemi/public_bug_reports/tree/main/172-warn=
ing-in-ext4-journalled-invalidate-folio/
>
> Please send the reproducer.  Note that if it requries a maliciously
> fuzzed file system, we consider this to be a minor bug (especially if
> the maliciously file system would be fixed when the system
> administrator runs fsck on the file system first), and not "security"
> issue, so feel free to just send it to the list.
>
> Cheers,
>
>                                         - Ted

--000000000000f86613065af0ec65
Content-Type: application/octet-stream; name="reproducer.c"
Content-Disposition: attachment; filename="reproducer.c"
Content-Transfer-Encoding: base64
Content-ID: <f_mts5j3u30>
X-Attachment-Id: f_mts5j3u30

LyoKICogV0FSTklORyBpbiBleHQ0X2pvdXJuYWxsZWRfaW52YWxpZGF0ZV9mb2xpbywgZnMvZXh0
NC9pbm9kZS5jLgogKi8KI2RlZmluZSBfR05VX1NPVVJDRQojaW5jbHVkZSA8ZmNudGwuaD4KI2lu
Y2x1ZGUgPHB0aHJlYWQuaD4KI2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4K
I2luY2x1ZGUgPHN0cmluZy5oPgojaW5jbHVkZSA8c3lzL21tYW4uaD4KI2luY2x1ZGUgPHN5cy9z
dGF0Lmg+CiNpbmNsdWRlIDx1bmlzdGQuaD4KCiNkZWZpbmUgSU1BR0UJCSIvdG1wL2V4dDQuaW1n
IgojZGVmaW5lIE1PVU5UUE9JTlQJIi9tbnQvZXh0NGoiCiNkZWZpbmUgTlJfV1JJVEVSUwk2CiNk
ZWZpbmUgTlJfRlNZTkNFUlMJMgoKc3RhdGljIHVuc2lnbmVkIGNoYXIgKnNob3J0X2NvcHlfc291
cmNlOwkvKiByZWFkYWJsZSBwYWdlLCB0aGVuIFBST1RfTk9ORSAqLwpzdGF0aWMgdm9sYXRpbGUg
aW50IHN0b3A7CgovKiBTdHJhZGRsZSBpX3NpemUgaW5zaWRlIG9uZSBmb2xpbywgdGhlbiB3cml0
ZSBwYXN0IGl0IHdpdGggYSBjb3VudCB0aGUKICogc291cmNlIGNhbm5vdCBzYXRpc2Z5OiB0aGUg
d3JpdGVfZW5kIHNlZXMgYSBzaG9ydCBjb3B5IGFuZCB0cnVuY2F0ZXMuICovCnN0YXRpYyB2b2lk
ICpwYXJ0aWFsX3dyaXRlcih2b2lkICphcmcpCnsKCWxvbmcgaWQgPSAobG9uZylhcmc7Cgl1bnNp
Z25lZCBsb25nIHJvdW5kID0gMDsKCWNoYXIgcGF0aFs2NF07CglpbnQgZmQ7CgoJc25wcmludGYo
cGF0aCwgc2l6ZW9mKHBhdGgpLCBNT1VOVFBPSU5UICIvdyVsZCIsIGlkKTsKCWZkID0gb3Blbihw
YXRoLCBPX1JEV1IgfCBPX0NSRUFULCAwNjAwKTsKCWlmIChmZCA8IDApCgkJcmV0dXJuIE5VTEw7
CgoJd2hpbGUgKCFzdG9wKSB7CgkJb2ZmX3Qgc2l6ZV9pbnNpZGVfZm9saW8gPSA0MDk2ICsgNDAw
ICsgKG9mZl90KShyb3VuZCAlIDYwMCk7CgkJc2l6ZV90IHNvdXJjZV9vZmZzZXQgPSAzMDAwICsg
KHJvdW5kICUgMTAwMCk7CgkJb2ZmX3Qgd3JpdGVfcG9zID0gNDA5NiArIDE1MDAgKyAob2ZmX3Qp
KHJvdW5kICUgMjAwMCk7CgoJCWZ0cnVuY2F0ZShmZCwgMCk7CgkJZnRydW5jYXRlKGZkLCBzaXpl
X2luc2lkZV9mb2xpbyk7CgkJLyogd3JpdGUoMiksIG5vdCBwd3JpdGUoMik6IHRoZSByZXBvcnRl
ZCB0cmFjZSBlbnRlcnMgdGhyb3VnaAoJCSAqIG5ld19zeW5jX3dyaXRlKCkva3N5c193cml0ZSgp
LiAqLwoJCWxzZWVrKGZkLCB3cml0ZV9wb3MsIFNFRUtfU0VUKTsKCQl3cml0ZShmZCwgc2hvcnRf
Y29weV9zb3VyY2UgKyBzb3VyY2Vfb2Zmc2V0LCAweDIwMDAwKTsKCQlyb3VuZCsrOwoJfQoJY2xv
c2UoZmQpOwoJcmV0dXJuIE5VTEw7Cn0KCi8qIEtlZXAgamJkMiBjeWNsaW5nIHNvIGEgdHJhbnNh
Y3Rpb24gaXMgaW4gdGhlIGNvbW1pdHRpbmcgc3RhdGUuICovCnN0YXRpYyB2b2lkICpmc3luY2Vy
KHZvaWQgKmFyZykKewoJbG9uZyBpZCA9IChsb25nKWFyZzsKCWNoYXIgcGF0aFs2NF0sIGJ1Zls1
MTJdOwoJaW50IGZkOwoKCW1lbXNldChidWYsICdjJywgc2l6ZW9mKGJ1ZikpOwoJc25wcmludGYo
cGF0aCwgc2l6ZW9mKHBhdGgpLCBNT1VOVFBPSU5UICIvcyVsZCIsIGlkKTsKCWZkID0gb3Blbihw
YXRoLCBPX1JEV1IgfCBPX0NSRUFULCAwNjAwKTsKCWlmIChmZCA8IDApCgkJcmV0dXJuIE5VTEw7
Cgl3aGlsZSAoIXN0b3ApIHsKCQlwd3JpdGUoZmQsIGJ1Ziwgc2l6ZW9mKGJ1ZiksIDApOwoJCWZz
eW5jKGZkKTsKCX0KCWNsb3NlKGZkKTsKCXJldHVybiBOVUxMOwp9CgppbnQgbWFpbih2b2lkKQp7
CglwdGhyZWFkX3QgdGhyZWFkc1tOUl9XUklURVJTICsgTlJfRlNZTkNFUlNdOwoJbG9uZyBpOwoK
CXNob3J0X2NvcHlfc291cmNlID0gbW1hcChOVUxMLCAzICogNDA5NiwgUFJPVF9SRUFEIHwgUFJP
VF9XUklURSwKCQkJCSBNQVBfUFJJVkFURSB8IE1BUF9BTk9OWU1PVVMsIC0xLCAwKTsKCWlmIChz
aG9ydF9jb3B5X3NvdXJjZSA9PSBNQVBfRkFJTEVEKQoJCXJldHVybiAxOwoJbWVtc2V0KHNob3J0
X2NvcHlfc291cmNlLCAnQScsIDMgKiA0MDk2KTsKCW1wcm90ZWN0KHNob3J0X2NvcHlfc291cmNl
ICsgNDA5NiwgMiAqIDQwOTYsIFBST1RfTk9ORSk7CgoJdW5saW5rKElNQUdFKTsKCWlmIChzeXN0
ZW0oImRkIGlmPS9kZXYvemVybyBvZj0iIElNQUdFICIgYnM9MU0gY291bnQ9MTYwIHN0YXR1cz1u
b25lIikpCgkJcmV0dXJuIDE7CglpZiAoc3lzdGVtKCJta2ZzLmV4dDQgLXEgLUYgLWIgMTAyNCAt
SiBzaXplPTE2IC1JIDI1NiAiIElNQUdFKSkKCQlyZXR1cm4gMTsKCW1rZGlyKE1PVU5UUE9JTlQs
IDA3NTUpOwoJaWYgKHN5c3RlbSgibW91bnQgLXQgZXh0NCAtbyBsb29wLGRhdGE9am91cm5hbCxj
b21taXQ9MSAiCgkJICAgSU1BR0UgIiAiIE1PVU5UUE9JTlQpKQoJCXJldHVybiAxOwoKCWZvciAo
aSA9IDA7IGkgPCBOUl9XUklURVJTOyBpKyspCgkJcHRocmVhZF9jcmVhdGUoJnRocmVhZHNbaV0s
IE5VTEwsIHBhcnRpYWxfd3JpdGVyLCAodm9pZCAqKWkpOwoJZm9yIChpID0gMDsgaSA8IE5SX0ZT
WU5DRVJTOyBpKyspCgkJcHRocmVhZF9jcmVhdGUoJnRocmVhZHNbTlJfV1JJVEVSUyArIGldLCBO
VUxMLCBmc3luY2VyLCAodm9pZCAqKWkpOwoKCXNsZWVwKDQyKTsKCXN0b3AgPSAxOwoJZm9yIChp
ID0gMDsgaSA8IE5SX1dSSVRFUlMgKyBOUl9GU1lOQ0VSUzsgaSsrKQoJCXB0aHJlYWRfam9pbih0
aHJlYWRzW2ldLCBOVUxMKTsKCglzeXN0ZW0oInVtb3VudCAiIE1PVU5UUE9JTlQgIiAyPi9kZXYv
bnVsbCIpOwoJcmV0dXJuIDA7Cn0K
--000000000000f86613065af0ec65--

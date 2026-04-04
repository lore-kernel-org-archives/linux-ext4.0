Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6593A545B
	for <linux-ext4@vger.kernel.org>; Sat,  4 Apr 2026 08:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775293157; cv=none; b=nH/iyhUzdCtaNvidhioin6bkq7ky9e2XQ4ngHzwe9Da/8pOAGHSowVdIxFDt5R+yXRtrkXtI6zl9Ra8EaZTM+0Vwp+3qFKfl1bnkq7hwcX4TBph4QjL6sCfLnduRANb547lOx1ilpF4U+zRgruV9rjFD+JAHkf0JHO2DFousyvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775293157; c=relaxed/simple;
	bh=uDJtadNJQtVClJNGz6Fgvc0qOOD8ZBGg7n46C9beoAI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=MjAEvHEJxbBZkIRkJ2vTo53L0/jFTxnE7gvejsLQutlvY+eYW1G1aVnFd+2OcKg3NRfGcdp5Mp6N5yR8aJBCwnn/QroCAMHaIp+YcTcup0jE/12ZkXBnWTfjZ0sEEyN+U+io4o4V6tJNti0D7YKKt3IbZNJwpOFvwMQxq6b3HHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=APBqtasz; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="APBqtasz"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-35d96be7c13so1524248a91.0
        for <linux-ext4@vger.kernel.org>; Sat, 04 Apr 2026 01:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775293153; x=1775897953; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+kz27emeQpXLA53ZgoxFIbwzHRJwb1l4CVdcohSXzQg=;
        b=APBqtasz4vbMdgpdGFkn84GpE9pncljnTKRYGWy7OCdn73MGUaNpbH9ICK96iyOXtP
         qWoPSebTch8oB9S1Lf1cGZXyuoln8KMRojTscs/tvHggnAc1658CtOLRA+BeqA4bnj1q
         GHVvYJlh9WMG+Y3h+drLI5mzEtjbUyEYaL0c4DaZyLwQlE8/sswI1ax3IL3uGpELKLkL
         onydV9tbS6vcy0lEFYyEmX7XAE8G9lK5jJYlMHVQ9WFEPzb2sgCkilQOauIjxB2+LrJ5
         kgZ0dNOqE/vIlViK3nseWYVMGvwEwJSl8FgRfQUk5hlWiYLU9uAuWLuXCUocIcQ7s1PP
         NSHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775293153; x=1775897953;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+kz27emeQpXLA53ZgoxFIbwzHRJwb1l4CVdcohSXzQg=;
        b=jtHnAha/GjUMJRA0OYzjgYnEHnv18H61XStdWyLJkInJF9dfYgSDXkDwDeOvHHTlYX
         Tt/OZ8CDRNChEXAWKiqAMaeQSA+/4kVxS1BLWUxjBYUNsvdFBb8flPp4NravZNit4XvM
         uxa8BxG57hw72ADwOOwJkRcypxbQd+CUKeTfujvgBVhxC0m/WBYDqaccE7frobBa1+k2
         /biHq1Bw+QHj/Yuk4rB+7e17KtJVBgYfdTP/D7bEzQCwq60eSqnABJtr3IH5DXMbxr2H
         lTx8CtC5PmTV3Tg5OmtBH21TNN0kmdDagWTsWSgUlUaWx0T6gN9K8Dim6j86nO0t0xbU
         MAYQ==
X-Gm-Message-State: AOJu0YyN7dcGyzQitJd2uBmigtdsH8S6JW0pyl4j/GPoGbGC6Etpgx2o
	X5hah+5UG2QDlKYIXX+Rf6PfCxPFq5beGG2JdtU1CXfItNjKRDuBIbO9
X-Gm-Gg: AeBDietYR3BYR6z9kGunKRJ8vGC8VpfAXLTg4047N44ytlW9OJXeufNNoI3j68U4P+C
	HTn69BxoaBRzunDRViZOnz5P7Zh69bEE+oJ+n6d9NyvQZPmFxCb81qOUoaFbyG1mTs+dmTh4COO
	WZRQB0coblBM/P7rIcE+ZG5tSDzX7kVN/LRUGXozB+FNtj5hO58Eqal4xBbKXRCmIPdK5Rba/Ko
	ZPqJGLEyGOuYO3iLiOp67BVKA34nOxgTXnfAaLeXKQe4Qg11DL/qTHuTAp3Fy0NP95qIIkraM4+
	+RRsRGDhLG5KdRqejxUbIPVb32pHToB9oe1Lg4ny0lyl/Q2iNkOPEJAM7LMs7cuYJMamlyj0GK6
	7Ef9saB974ZVWV3iXEAwqVzXYkd9GNNrA1mFv2lwr8N3JaPS2bR562Ustv99Ees77NSQMdopO+r
	Sux1qUEJGX1nHStYQ/U0/vKPFdTFk=
X-Received: by 2002:a17:90b:52cf:b0:35c:195e:112f with SMTP id 98e67ed59e1d1-35dd68b3edamr8054586a91.18.1775293152635;
        Sat, 04 Apr 2026 01:59:12 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76c6491fe0sm6489143a12.11.2026.04.04.01.59.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Apr 2026 01:59:12 -0700 (PDT)
Message-ID: <5bda3d00-df35-4ea1-b313-2fef6e5c5682@gmail.com>
Date: Sat, 4 Apr 2026 16:59:08 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] ext4: derive f_fsid from block device to avoid
 collisions
From: Anand Jain <anajain.sg@gmail.com>
To: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
 "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-xfs@vger.kernel.org, Anand Jain <asj@kernel.org>
References: <cover.1774092915.git.asj@kernel.org>
 <33e8eb64c304a4d42b60f608c26497bf9a2e9e19.1774092915.git.asj@kernel.org>
 <20260323041624.GA11453@mac.lan>
 <d4a9970b-e7ed-4e74-be9d-2d08400f9d79@gmail.com>
Content-Language: en-US
In-Reply-To: <d4a9970b-e7ed-4e74-be9d-2d08400f9d79@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


Hi Ted, Christoph, Darrick,

As I prepare v3, I'd appreciate your final thoughts on the mount option
naming and its necessity for ext4.

For the new option, I am considering:

  -o nodup_f_fsid

  -o unique_f_fsid

Context:
Currently, ext4's f_fsid is consistent across reboots but fails to be
unique when dealing with cloned filesystems (sharing the same UUID). Per
statfs(2) [1], the primary requirement is that the (f_fsid, ino) pair
uniquely identifies a file. The man page makes no explicit guarantee
regarding consistency across mount cycles or reboots.

Proposal:
With this fix, f_fsid becomes f(uuid, dev_t). This ensures OS-wide
uniqueness and maintains consistency as long as the underlying dev_t
remains stable.

Dilemma:
While statfs(2) [1] suggests f_fsid is "some random stuff," we know
userspace (NFS, systemd) often treats it as a persistent handle.

Do you prefer one of the names above, or is there a more idiomatic ext4
naming convention I should follow?

Given the ambiguity in the man page, is gating this behind an -o option
necessary, or should we consider making uniqueness the default behavior?



[1]
----------
statfs(2)

<snap>
       Nobody knows what f_fsid is supposed to contain (but see below).

<snap>
   The f_fsid field
       Solaris,  Irix,  and  POSIX  have  a  system  call  statvfs(2)
that  returns  a  struct statvfs (defined in <sys/statvfs.h>) containing
an unsigned long f_fsid. Linux,  SunOS,  HP-UX,  4.4BSD  have  a  system
 call statfs()  that  returns a struct statfs (defined in <sys/vfs.h>)
containing a fsid_t f_fsid, where fsid_t is defined as struct { int
val[2]; }.  The same holds for  FreeBSD,  except  that  it  uses  the
include  file <sys/mount.h>.

       The  general  idea is that f_fsid contains some random stuff such
that the pair (f_fsid,ino) uniquely determines a file.  Some operating
systems use (a variation on) the device number, or the device number
combined with  the  filesystem type.  Several operating systems restrict
giving out the f_fsid field to the superuser only (and zero it for
unprivileged users), because this field is used in the filehandle  of
the  filesystem when NFS-exported, and giving it out is a security concern.

       Under some operating systems, the fsid can be used as the second
argument to the sysfs(2) system call.
----------


Thanks, Anand


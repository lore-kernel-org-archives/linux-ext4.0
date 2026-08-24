Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C022408018
	for <linux-ext4@vger.kernel.org>; Mon, 24 Aug 2026 11:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787572396; cv=pass; b=fdnSm8bX3aUPxNxB1AWf07PB3cfGUo0RB6r5kGMjusef6o+lLnUZYqYxqRjrhfGoH6KYNd32I9DRVEbMRA1eoOv7MCutKzg9Vv4LYb9z7vYKLhGaPUanIy7VDvp0MkEqlg1R/W8g9QZhuy3veazX3pO9wAimuBUGu7T2NhHpwLE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787572396; c=relaxed/simple;
	bh=M2g4HIY98VkeNiskOU8NrgO0csw78dC2NkGbpY8M/rk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=fc6N5dJAOB9wHRntNjraW+5/AVKU+ItxffvJMoUcholHLNd0VzuBoYMaA31MUIlqy4tf27cBpoXGz9KDM/M2pA9uUhbe0280/XEbpY9qUC+Xag4ejnmIAmEQTPXsANhAX1uh40jP3V9us+viRMQPCbpqw2hKf/b+6uim7lvgpfg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hql9wTSX; arc=pass smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hql9wTSX"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8f29ec73064so18085516d6.1
        for <linux-ext4@vger.kernel.org>; Mon, 24 Aug 2026 04:53:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787572394; cv=none;
        d=google.com; s=arc-20260327;
        b=AFVXZvLUHI39QJhu6Hor14EvmM2lAPqKA73YZgz9NkrjqiVP/tUubCGcGJVZ99QPw6
         5Js1kKnf9DtUOfeg0d5+LkZMAn3zcwMSswqVI/T/CH2KM7OR6EUS8sLhru7MmdseyEZN
         CnlPVV4llERI6+SkwpREiIFDtzqZCQscBtBGG9084eGK36KRobI/4+4lwPFGsoXXxj4b
         EtiOGdrNHmIDSqtYlUX5k30l06BQw8WbniE78b7LYc3FX8ZyE0+FJahznI2BZVaBTfsH
         6IRT2535rTqJk3nTKemDL7unSI4v9IxPsQlhl5mlhxfzC33D7YLPPq6qudhlqrjBPrIU
         9atA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=8XHy3dd2bxETRxA2KG8RFG1nkfGg9gAvEyXFbhMNPi4=;
        fh=3IlOq0qbsYBafph5307qRCN+2HHdgXuN6Eh+kZU30Zs=;
        b=Wj6mf/ozOWIhOQRt1Ax2XLxt5nO5EyFJgwb9142iE/X9EWU0js1fYJ/NrynG1wWEe1
         Vr5+YLH4hUAVExSJ2VwRdnuRKFcDkS3dYpwP2jTKbr+x08m+wywf9+q8WN02tGxBVBvO
         QvuicvT6BZh51d7lKN6x9Jr+fLX+5oqc1FGtcpSp8n5SSaScwBnAJFGuauKanlv110Wc
         bFvY7u+xer+yQJ5gZwgxnseoCdVObhUz5oRWDF6gwbEUPWGIyylxMItJyUizJlu97Zi7
         qPl+dndQBTP6UJSNdCJacdCEnL5rcZeV9J446TFJBLfdxaHzRkwmjhBaX26NnAfi/5k8
         y8CQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787572394; x=1788177194; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8XHy3dd2bxETRxA2KG8RFG1nkfGg9gAvEyXFbhMNPi4=;
        b=hql9wTSXHk9G4T4zfpWhkjF70OvLQ3H2sen7K2002cUH5ygDKmZtm6GVFDNkgpOg3P
         U0cmJKex0c4fkozO4+QsA08PR4FWDjESczDFTJSbFAICI8Lo2vuE0fIK1WcoyToGSajs
         Jin32jQTzb0iZQjghJ3Mu94cAsGo2D4pauywYPpbTm/cOIpMVjVdZJDrO6VUaMKSf/c+
         a7xWU4EoUC4eqXK+pQcDjmF5PJuZm4OSbrfK9znotcZ1SJ4SFKzJy8YgZax1+A//9tY1
         zJCHqrpk61kYVxOMR79SSWttRqXnP2LJ1YD8+X2ub6ry/NTn5gfhPzaSFHMqEssCp/09
         JFLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787572394; x=1788177194;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8XHy3dd2bxETRxA2KG8RFG1nkfGg9gAvEyXFbhMNPi4=;
        b=gEem7MVttroWRZ1dRWl9OS2Gv9CfPcvgtBqlTRsFvt7fPR+B13GUhj8aJhFTrgr4HD
         ZChVWulo5QmPDdXtqWAHET1z6U4qNjdgOzuJDaNHnmaAlDKocYjBtqebv/S2rWPVWUpl
         KTYEoICI3AKIx4xaKDEtfIzstalt2lc6yBC1cDt8Mjolcl6FiFt1pSV+hVIUhbJ2ST0z
         CV7KdUA61HSIBwVh4erqGXBIJXtKkUfjPuf8k/ByQ/066Q+UBl4LDO/f34l8/Qj10y1E
         5hOVFEvxbIeAY+B6ukgYJCkEo//n5SuRJar9M/2npxt2qAqSy9ayvyzK+fYA6WM9PJjl
         7OKg==
X-Gm-Message-State: AFuF++lHXeY3GMknZc0JiL7NeNGwQ29yI/WD1ugrZQedDQyX0huo7Ntc
	LioXA5HEOa0lTFZ0u0P7dB1dRB6wZWCr9mRuSdFoev0UiWTBnTw8C/EJpsJKnxjrlLfRR57Kgz4
	AiOZhruxScPwdE1AcRLeukpUayyzdTfw=
X-Gm-Gg: AR+sD13GRQUSFOD7g8tWpY5cvJYaxnw6wkaohACjHkS2wbczxy5afd2zbg5IHf4VtlN
	sRWXZDDW6M5mfGF0ceBcxsn0v1sFdIxByQ4sEOULzRGiKucCLaXpxP+yojdj+zLHvPusUssa3Tv
	alvRJWPOUXF0GXVaemagKOVHP+fEFQSik8yxold1k6khD5dzLo4NI04ay2Vzxk5iRFwCrVQpiyo
	TPyj5GZUesItDL0fVh2f2hoHat+td8CBn1bJXK+ATmYElpyk0544uaKkuuRMIPGV8HVHKT21DpH
	GnsKzv1NwnoaYYovEu2fU1G3lGdkzNq1JB3JYWzLBzyS
X-Received: by 2002:a05:6214:258f:b0:907:dd19:fcb3 with SMTP id
 6a1803df08f44-90c80f93275mr241274906d6.24.1787572394192; Mon, 24 Aug 2026
 04:53:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Slava0135 <slava.kovalevskiy.2014@gmail.com>
Date: Mon, 24 Aug 2026 14:53:03 +0300
X-Gm-Features: AcwNN1X1Hsubl1ksV26rgEjXm3udO8ZnbCvpoMMNHCb7ONXmv8kGxz68y1t3Kfo
Message-ID: <CAAJYhwzHRMipEy=mrH_FwELcSCCk9zK7ifzy0cuuWMzX3wmVtg@mail.gmail.com>
Subject: Error loading journal when using ext4 with fast_commit and calling
 fsync on unlinked file inside directory (if system crashes)
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Detailed description
====================

Hello, there seems to be an issue with ext4 (fast_commit) crash behavior:

1. Create a new directory and a new file inside the directory.
2. Sync filesystem.
3. Open file.
4. Unlink file.
5. Fsync file.

After system crash (e.g. power failure) mounting file system results in
error (`Structure needs cleaning` / `error loading journal`).


System info
===========

Linux version 7.2 & 6.17.0-29-generic (Ubuntu 25.10)


How to reproduce
================

Test:

```
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

int main() {
  int status;
  int fd;

  status = mkdir("dir", S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
  printf("MKDIR: %d\n", status);

  status = creat("dir/file", S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
  printf("CREAT: %d\n", status);
  close(status);

  sync();

  status = open("dir/file", O_WRONLY);
  printf("OPEN: %d\n", status);
  fd = status;

  status = unlink("dir/file");
  printf("UNLINK: %d\n", status);

  status = fsync(fd);
  printf("FSYNC: %d\n", status);
}
// system crashes!
```

mount:

```
root@ubuntu:~# mount /dev/vdb /mnt/fstest/
mount: /mnt/fstest: mount() failed: Structure needs cleaning.
       dmesg(1) may have more information after failed mount system call.
```

dmesg:

```
[   27.437203] JBD2: journal recovery failed
[   27.437206] EXT4-fs (vdb): error loading journal
```

Steps:

1. Create and mount a new ext4 filesystem with `fast_commit` option.
2. Change directory to root of the filesystem and run the compiled test.
3. Cause hard system crash (e.g. QEMU `system_reset` command).
4. Remount filesystem after crash.
5. Observe that mount fails.

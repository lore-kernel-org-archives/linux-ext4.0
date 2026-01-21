Received: from mail.acc.umu.se (mail.acc.umu.se [130.239.18.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED00828506C
	for <linux-ext4@vger.kernel.org>; Wed, 21 Jan 2026 17:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.239.18.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769016256; cv=none; b=IOkGXLN3FvW4+p5gNFieqyrEkrkJIPkdQ/ReVZJZU1Z8gk2TW0VvKfVcDDDh16d4hTZMtIxWCmP9gqQ+cH50EQEFeJbADjVgi8HBluKpqmb5s/i3aWNZA/+HvBkP5zEl04NJYBHiW8hxx3hGAHK/x9ANb9Ah6wT1NXH6z3YMjSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769016256; c=relaxed/simple;
	bh=2IMNMZ41XRm1WVL/4SSaGtDtRDtMOwrz2VKntnrVUi4=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=ZPMuHUkR6Vk22udl5gSuEymdrXT6FOnzGcl+k6gRku9mQ1heIO3rhBmb5s1Gm/Vy8Kvx0+81/Wu9/HNUZjfePWKTgEQuOU/miIw8Q8WErBLcAGnKZGa59WK49yc6XyCbO9aHZLQTTymioureFa4x1vJOb+qyF7jlQoBQCA0Eja8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=accum.se; spf=pass smtp.mailfrom=accum.se; dkim=pass (1024-bit key) header.d=accum.se header.i=@accum.se header.b=UQMH/Iv/; arc=none smtp.client-ip=130.239.18.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=accum.se
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=accum.se
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=accum.se header.i=@accum.se header.b="UQMH/Iv/"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by amavisd-new (Postfix) with ESMTP id DAB2A44B91
	for <linux-ext4@vger.kernel.org>; Wed, 21 Jan 2026 18:15:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=accum.se; s=default;
	t=1769015729; bh=2IMNMZ41XRm1WVL/4SSaGtDtRDtMOwrz2VKntnrVUi4=;
	h=Date:From:To:Subject:From;
	b=UQMH/Iv/Q7rRk1CiJ1ZW1pJ2QiDGERcHeTz0dOf1e0YmXb75big76xLcV9A9B7iHt
	 koluvXCy4TWvMVyUxIi0kUKbDULsCm8JI1mAWZlZ+T6DAkbXqAZXXJhcWtJFlU1G3z
	 uoAbIowY4uKkcFwB6W+DLhPyOqUs5jNNLAvOeorg=
Received: from suiko.ac2.se (suiko.ac2.se [IPv6:2001:6b0:e:2018::162])
	by mail.acc.umu.se (Postfix) with ESMTP id 65C9944B90
	for <linux-ext4@vger.kernel.org>; Wed, 21 Jan 2026 18:15:29 +0100 (CET)
Received: by suiko.ac2.se (Postfix, from userid 10005)
	id 5492B42B4B; Wed, 21 Jan 2026 18:15:29 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by suiko.ac2.se (Postfix) with ESMTP id 51DF742B49
	for <linux-ext4@vger.kernel.org>; Wed, 21 Jan 2026 18:15:29 +0100 (CET)
Date: Wed, 21 Jan 2026 18:15:29 +0100 (CET)
From: Bo Branten <bosse@accum.se>
X-X-Sender: bosse@suiko.ac2.se
To: linux-ext4@vger.kernel.org
Subject: adding the casefold feature to an ext4 driver
Message-ID: <74d20d0-ce31-fc8a-de6-2a7d5da6782@accum.se>
User-Agent: Alpine 2.25 (DEB 592 2021-09-18)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hello,

I am helping maintaining an ext4 driver for Windows witout being the 
original developer and I have latly studied the casefold feature because 
the driver does not mount a casefold fs as default because you decided to 
make it an "incompat" feature instead of an "read-only incompat" feature.

When trying to add the casefold/unicode code from the Linux driver to our 
driver I discovered that this driver has been casefolding all the time! 
However it simply uses the standard functions strnicmp and wcsnicmp. This 
is not exactly the same as your implementation but will give the same 
result for non complicated filenames.

So no I am chosing between either always allow mounting casefolded file 
system read-write without any further changes to the driver or possible 
only mount them read-only to be really safe?

(the reason most people end up with a casfolded fs is if they run Wine, 
possible on the Linux distribution SteamOS and later they want to read 
some files from Windows on a dual boot system)

Bo Brantén


Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5238D378813
	for <linux-ext4@vger.kernel.org>; Wed, 22 Jul 2026 15:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784733246; cv=none; b=c5CdCcYkkPVvKz1Hi0zxli2fHGTaB4jmk25orJ3PNC2y2DclJ9TXTGEMARvrVJPCqJhneJBSuM9FH3DQugcpwzIBDdMv48228H4HPhuF8UlVc7KpqpYnQnJoKaXW5B6DZxDZ5YmEMJ+ky5RqaZmjwHywk6rRPH7CJYq/gBjozLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784733246; c=relaxed/simple;
	bh=oneXgL8ugv1IfWdNEXtlbTimW7vlfwONR37hKlF46Mw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a4fX8y1g3KCUBnnzTaR95z7eJTsKc9GkCnXkIIlEm5vDQinb2dxbK+BIB9SPrRT7bg6Jun81+4cp+VhC589m77bsTlg9HhS2qfotHkazMch10eEUOWghCb4mTIE+z8xPXhRn6DCDJgPSZ6dTSB+wXEEGE50SceXtVA7T9QvJ11M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=i0Ye/tBX; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="i0Ye/tBX"
Received: from macsyma.thunk.org ([104.135.218.89])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66MFDm3J022270
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 11:13:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784733230; bh=s/ndAhIOTHAZxNI7oRFMCpd2mBjLKp6AgT9NPabHcoA=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=i0Ye/tBXI4yMnzKS7D5tQojvneaxcgFJk8GJJEDAKG8RqgXC0m94odL6cY509XKS+
	 LTOmj6xjHxFMJEK6oOqQWhu5J1FitKWvOVsh5g6X2DXpNIl3iLYVpugOTSUqxxNRrG
	 qArbc1KY+5Vkg11lhRHzG9rS/02wi3gkz9ksTgIcJE+q1hXUptDVrNtXz3EEoELzln
	 NyFE8Xii0A+oWI8751v0ZYWGhDsgQY3gE2STifHgtpxNLxIX8q/BD1rtPTMGInR+jc
	 pPs6j1SnBWCh1ZImqXLDOVdKVwc9eJML4TNbNWJb44rJvpwTVBCvYqIgiVcOmWNFSU
	 SqLNgWGT2TSSw==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 63028BA5DD0; Wed, 22 Jul 2026 11:13:48 -0400 (EDT)
Date: Wed, 22 Jul 2026 11:13:48 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: dardaoe <dardaoe@proton.me>
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: linux-doc@vger.kernel.org
Message-ID: <amDdRu-RE46utVe5@mit.edu>
References: <F6-Nv2DhZIxD7g0KzZFf36UXOLn6D8qTlOQQFjIuQb_GyiQtoEQCvvRzDKnpYeSrd_E9H_DQYygw1zBDzlR2KxqqGsmYjODQr2qmRdjuixw=@proton.me>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F6-Nv2DhZIxD7g0KzZFf36UXOLn6D8qTlOQQFjIuQb_GyiQtoEQCvvRzDKnpYeSrd_E9H_DQYygw1zBDzlR2KxqqGsmYjODQr2qmRdjuixw=@proton.me>

Thank you for the documentation corruption.  I've fixed up the patch,
but in the future please look at the Kernel documentation about how to
submit patches[1]

[1] https://www.kernel.org/doc/Documentation/process/submitting-patches.rst

In particular:

*) The one-line commit description was not correct
*) The signed-off-by line should be at the end of the commit description,
   not at the end of the patch
*) The diff was corrupted because of how you sent it.

Best regards,

					- Ted

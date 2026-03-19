Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B195382F0E
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2026 14:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773931556; cv=none; b=rvuHMX21ucM4iOSLSzy2SrhyRw7GzR+FGJb0ENbZCS3D2vH6e7jZ5llO9z5YDPzALscH+jTOSt+3AxmQcwl9aOORlGyrN3+q03JDSmbCOKJC+hXwr4tjpnZSrsTdLhb3YGfLAqCM1bx8RGkNqpqLQXtUTeXAnd6FI8WEVuMjqbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773931556; c=relaxed/simple;
	bh=7oYYNARqPGzIMmkTNdv5GkV4g6q3vZNAcesI4J4PJPw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ue4M3F1G5eF++NeqmIcaj35E6CQRjeR3jnkZGdoBlkEj4l2n9crfnDIUHWMzh6AVb5BpB1o1y+EkWRFOFBUiL3lS1XdpaZ2m1yMEOsbZqSfv4CAlIt1drrhEZjoVwWNHRCulocPnx/UEy1m9PJ2r25Pxkehv3DMmheEoCtOtonU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=JL7ljKkt; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="JL7ljKkt"
Received: from macsyma.thunk.org (pool-173-48-82-102.bstnma.fios.verizon.net [173.48.82.102])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62JEjiOS028712
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Mar 2026 10:45:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1773931546; bh=EPyTEqibWQ9T2kliC5Z6AeszNQQc59/1Iq0TZAyVylw=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=JL7ljKktjxEhym6KbohYymeunNQRNhxKit0aHAbv7XbAVDLj6XNWqyw3ZyYusPTUh
	 4Ne+F7wKWdlbFJWYdD/AJFIci3eZ3h8PPaa7Lea/7441zRW2QXOD+uE0Rb5saHnkVP
	 LAuqLXS94puj31dDWZe+OiRB+2UE9LBkHF9PSnktE1lSYHsaj6G7wK7GZ17cjIa8qD
	 RBEehgDeHOqihSDr6kQrH7dyUmMQzE/s46FF6h3otaWg/KEwEfh0U58LTIwZsWwVzW
	 SqRg5eaBIPnPEF6rJxtqzFajY/UqQHiL0yCRK1y5KpAFEiEpSUV0L+wFyjeJSjRnTT
	 YiQr6oMoq/c6Q==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 9048B5E4D116; Thu, 19 Mar 2026 10:44:44 -0400 (EDT)
Date: Thu, 19 Mar 2026 10:44:44 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [GIT PULL 1/9] fuse2fs: fix locking problems
Message-ID: <20260319144444.GA14752@macsyma-wired.lan>
References: <20260312205728.GA6004@frogsfrogsfrogs>
 <177334916459.3254574.17133177610807268883.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177334916459.3254574.17133177610807268883.stg-ugh@frogsfrogsfrogs>

On Thu, Mar 12, 2026 at 01:59:39PM -0700, Darrick J. Wong wrote:
> 
> Please pull this branch with changes for ext4.

Thanks, pulled into my next branch.

						- Ted


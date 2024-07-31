Received: from spornkuller.de (spornkuller.de [89.58.8.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1891AD415
	for <linux-ext4@vger.kernel.org>; Wed, 31 Jul 2024 11:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.8.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722424511; cv=none; b=saB4lh58796RfFPiqitQqX48v7l+i/nX4RGLkNt0VYG3LYFN4mFHJb+nee1zzRms+zhKsN9e+eCI4joEcYlZCZlPp5pqVQn8wnsj2LEfzW2rtPS/BzSf549+yDPZW7Ou+WKbfS/av7eoq/XgdtKJaLzXifOc+LFvqpQzN8Cyq4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722424511; c=relaxed/simple;
	bh=bIkL3j1SUti+mxRknWXsGzjEHfZ++LfAOrCAj6OvBfk=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=oPlxziRrbzywB5mJGk+A0p6pckpF6CHSYOvt8cC0JQfCuE+C0+FHownXLFTHJ8bvzm+7cajhCo8DG4g++UpyIKhrOJXuNYCmKh0G/f67PoL7qsd3JdtZcaciR5JyLBS5070jxZJ5If67UoD62T8bLUfO0tfO6uNTZQn/q3zLDWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=spornkuller.de; spf=pass smtp.mailfrom=spornkuller.de; dkim=pass (2048-bit key) header.d=spornkuller.de header.i=@spornkuller.de header.b=Rd2rTk9n; arc=none smtp.client-ip=89.58.8.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=spornkuller.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=spornkuller.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=spornkuller.de header.i=@spornkuller.de header.b="Rd2rTk9n"
Received: from [IPV6:2a00:79c0:768:fd01:b3aa:d19e:128f:14c] (unknown [IPv6:2a00:79c0:768:fd01:b3aa:d19e:128f:14c])
	by spornkuller.de (Postfix) with ESMTPSA id C43A6636FCC
	for <linux-ext4@vger.kernel.org>; Wed, 31 Jul 2024 13:06:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=spornkuller.de;
	s=dkim202204; t=1722424010;
	bh=bIkL3j1SUti+mxRknWXsGzjEHfZ++LfAOrCAj6OvBfk=;
	h=Date:To:From:Subject:From;
	b=Rd2rTk9nC0ARN8iYbh6p5NzLdy++j910OamU3aapembkFnzI1XfvHMlS0HYz7lK9j
	 bqCeT2DxMKvxlB8egOMmDahh7cDvR46Xqji3WldCURvoHmXS+Fzy+KlOBXdj9d8LvA
	 7e+zJtXrCG8NrHwu8GRhdMcd5J1feq8yHcvb6sKsVs0/4pgOs0viIdnjucDZcI8GT9
	 I5K66+IzmGD0w1WmmhziEWHBJde3iOV6cv4b+b5faYGOrSiVcEqCIDjFFmUkStv9pQ
	 nSst7F1g3Cf9wX4z8LlKZasZ4dHc3DZPis56SCXu0lOltl7ZZDYhwBS+TNJdW3GHUa
	 +AHb3pImVfYYA==
Message-ID: <23442aab-e62d-48d3-ae84-8ea3c0555513@spornkuller.de>
Date: Wed, 31 Jul 2024 13:06:50 +0200
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-ext4@vger.kernel.org
From: canjzymsaxyt@spornkuller.de
Subject: subscribe
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

subscribe

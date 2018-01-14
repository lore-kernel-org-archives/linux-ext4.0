From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 198301] ext4 fails to create symlink if target length is
 greater than block size (but smaller than PATH_MAX)
Date: Sun, 14 Jan 2018 00:05:38 +0000
Message-ID: <bug-198301-13602-PgjhwfJ4vC@https.bugzilla.kernel.org/>
References: <bug-198301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:38772 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751168AbeANAFj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 13 Jan 2018 19:05:39 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 1BD3028874
        for <linux-ext4@vger.kernel.org>; Sun, 14 Jan 2018 00:05:39 +0000 (UTC)
In-Reply-To: <bug-198301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=198301

--- Comment #5 from Josh Johnston (josh.johnston@hotmail.com) ---
Here's the way I tested this:

1) Create a partition at sdb

2) Create an ext4 filesystem with 1k block size
$  sudo mkfs.ext4 -b 1024 /dev/sdb

3) Mount it
$  mkdir ~/smallblock
$  sudo mount /dev/sdb ~/smallblock
$  cd ~/smallblock

4) Verify configuration
$  stat -f . 
  File: "."
    ID: b3305705f96e1be2 Namelen: 255    Type: ext2/ext3
Block size: 1024        Fundamental block size: 1024
Blocks: Total: 93095    Free: 91545    Available: 84520
Inodes: Total: 25168    Free: 25157

5) Expose bug
$  ln -s
8c3393ecb2a669e63f2311d3bd1733a769d960c727dac9f7cdc0518fc77b0c63a9c566d3d5fe9bedfae035235608b85de179aede4dc9ef29c4538d4547a63c4/c98090877ea9e99900bd9b575360f3f3ed29ef0536691f4487a9b6dad80039010a6fdfddde4d47ba07539a95bb26ddc3644e7e788b16bd56a900237834ed95c/b580f8f8d4123dbf2aac4d55aaec0007cd5b11e6f07169e11fcee13c6677f9ea5088dd38a019eb0fa0f78fe26fc27b79c8a9eb3039580407c23e2d418f67ac2/38b2f484e1712a33138304ded70675dc1ee1127198a99e716087c2f2b349ec73f216ace4156253b79d4378472638ffb44c38e6ed9f70f88de720f09eee75d91/e0fb67e85f5461a5f57fc3fa5775fac66a75d24032f04d1fd8829f5cf019d2ea8cc845a51bd8f039fe566332233b719f8915bd7adc2f4cae054b18015491021/ff278ca4536a0d307ec0a20cf6405b5d2eb9471e7e1f8d980c38bcec5b9d2a89e785084e6b8f1ffe2e7e172b0b460f8c35127771b83100a3daab8992f5267af/c793a3258a23fde2c72b847faa24e7c5
 755728da1ddebcdafa6f866b37ac02f35c509f88a8169d195ddf533ea013a7dabfc0172e9d9339c039ce96c52228611/d28f37b47a3f8aff33bd854d43977f345f305a6dce271fe84f48aaf67df050f394faa3d6b96e23bb08d9fbe9b6853281e6821bfc6dbc3a536460454a4081df5/0dbd49325941f8e22966a08bdce5ff5c26cd545fe3f05e77fbe4fce6fa18e70423712c0e8ec8fc9d5c32b1e852358d034bcd774ccad17282ae6e2b3f6242a3b/062c3c72ecb3674edc722b9f43b00b650336118cf93301c99f73a56e9eba410f8839eceb2142f0689061fa04a322904b2094b1e1ad8b0ab5dcf286a81b369fc/f5ee3045cff41c71f9e8e17dec9de6d308b1a41c7c09a2ab894633d9f0a5e375df9c4bbf82aa4030a46aced1204f807d1c21ca48bcb290eee18cbd1590fec5c/96d9f673a0c574d0dae5ef10eec35ab999cc81007fa1a3f3c77d830c955cf6318806631c6a25c1121b93f1791f7746f851917b7356a165a2fb2c0ba632fec5e/b78171c2e9cbebffba9ac2bb274541029a92e7b3772388230765fafa3b2857
 f40b7a65100fa382759f66ccec69a7881e112dfb41ce3d1044bb66f52a6ada3ec/033848915fe4ab01e770dc3c627f67b08e9d2cafab557835174b0fe2bace83a025556a4a93ee291c3e7b14568fdd0ff7e127c944e14a735c4208aef17083a58/c123e653f0a6a8f8be21d8af19d8f07d9d2b88b7cb8617d75a70e56cb3a0d56e573e242e9c06438df4dc4eca13006643704967c9a66f8a5714257a863ce227b/d59c110b891221028f31eddfcec8240cee92808e90f7dfa304b20c6fbfaddc2382bfae959bbab0f0213bc90f110a99ac37582df29621d2b295834a0ee1bf629/71f908c369b29b8addf781e5070ccb61983238c7002fdffb9a402fbcc5df1acf4d5dfdb974555b0a61df9ae34f1299b4ed7f6da7bb628926f20e4198efb8899/16218ba4328c7386a4d9fcc21dc38619babec0651494c0f267972ee9781335530dde150fed88285d28e09569e0abfa7e4acc0a6399f639c886d847877d89a9b/f41b08283928d22948aacddd584f726328ecc4273b8ad27938cf37e2ad072ddcbc1a0e9f66814745d9ee34e1f029
 9458f5e39ecb64762b751446282fea48e8d/c4210ca57e10570a98e048985c447396d2a910321731781d08c52a13400a9966a11e449f91984111b98a3d4fb732215a0e918971ba818bf3fd5427a7a7326d4/cb6880ebd00d2bdbc49b9fb22fb21591663e210aad8a4436d8ec38611ebf41bcda74815f5e2f394c2e692fd352e8d8410b1c6272789274462ca8dd70bb950ec/88f22ab7776991b406ded8da27288f1e10bdd25e03711ff6d7d5194f9d7b1d9a498edad864e6964bd3650de2aa778b85d512221c6ca006acf6a0dd99db8d5d2/8e4581b6764504181a52d2e3620c413ccdae6f0bb74b830e3552730f8e00d3ec79d645884abf0eb32f5ee2023232392f00566e7e7e2f52f4a739872cfedb341/375554af7b64a34009c23a601be444856fd637115324de90d1fb9cb3077a8be764434af8e3bf71c04e47779733bb8f6fc54491cd126f795751b3b3ebc9bd6c6/64fbddd4abfe4f337fab5fad93849a0f9dbc1b483d344698f258f2a88cb3271ef176d7b4bf2d9208f1fa4dd63375a329c7dce4f229f65732f9bd48ed14
 41084/edc6ff1c247ea26dbc8196c1bf03ef91d4b161eafc793960869cd3b0554a000c128f4530130b276dd11b9447cf77599dcfcd386b862b0b9d41306e59d168538/54b62df2dc4c07f143f6ba943be094419ea516a24a4449cfab65805b82f2b480903bb589919c53b85493fd99fc0ed0fa0251e3678484128410c241fe01b7074/c361fc4d819714ef241aec91ed439886d8af28278f4fe888f8ef4ce13f4068491f04db6417f7bb909b2c71da9478ead4f5ae5b63b1d297756be8f8fb665b7a0/e27891a3afca9348d65c194ea8b2985e0aee4e4048e4418b8dbc2df1cdd531009e4b1928b01c646beb80375cfdcff5324adbdd3b293d0dc8cbfcc3bc186dee8/a9a73da1951a76e446bdb89084aed99f016c1af3fe9874015123eeafcd59159cfd01d8057d31e44a77d02f4c9b39d78b8742ad140611c2fafc5b8e6972ccf51/b6ba7e498f168859496d601fdbab243b50e646febf957b6743618811ae1317c0eda0ef7394712a4ecef2a5b30bee76fe490d2da199059660b6ea0ccadb567f8/
44f4517205b7b6e21a9cc55e2b379e2c112d0e407153d367bffb5d1bb9941522b6a6b251aa2ff91453322ec7c65a86329f4ecb16acdb4fe4d42673f69da3e8b
pjdfstest_1ed95816e0eb09f8b38de6019ae5675b

This causes a name too long error

6) Patch, build, and boot into the new kernel.

7) Repeat the above, broken symlink gets created without error.

8) Remove symlink, create a folder with:
$ mkdir [The long text above] 
Create the symlink again.  Now it works.  I can move in and out of it, create
files there, etc.  

If I remove the folder the link breaks but behaves as expected.  If I make the
folder a little shorter and create a file in it, I can create and remove the
symlink to the file, as well.

If you can suggest some other tests I should consider, I'd appreciate it.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

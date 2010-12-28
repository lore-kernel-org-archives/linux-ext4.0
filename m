From: torn5 <torn5@shiftmail.org>
Subject: Ext4 and scsi commands resubmission
Date: Tue, 28 Dec 2010 11:41:58 +0100
Message-ID: <4D19BEF6.5010007@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello all,

in open-iscsi, when network connectivity is lost, scsi commands that 
were in-flight at the moment of disconnection are failed to the SCSI layer.
These get resubmitted up to 5 times by the SCSI layer (or so is written 
in the open-iscsi docs) and after that they are held in the queue 
(device "blocked") until the network connection is restored.

Now the question is: when SCSI resubmits commands to a device, I suppose 
they go to the end of the queue for the device, and not at the head like 
they were. Am I right?
How do filesystems, and in particular ext4, react to that?
I suppose the ordering goes awry, barriers cannot succeed in this way, 
especially if they were submitted as real SCSI barriers (i.e. without 
using flush + command + flush workaround)

Thank you
